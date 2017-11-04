//
//  ProfileSetupViewController.swift
//  ColemanJustin_FinalProject
//
//  Created by Justin Coleman on 10/26/17.
//  Copyright © 2017 Justin Coleman. All rights reserved.
//

import UIKit
import MaterialComponents
import Fusuma
import Firebase

class ProfileSetupViewController: UIViewController, FusumaDelegate, UITextFieldDelegate {
    
    //MARK: - Outlets
    @IBOutlet weak var profilePicContainer: UIView!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var usernameInput: MDCTextField!
    @IBOutlet weak var bioFieldContainer: UIView!
    @IBOutlet weak var progressView: UIProgressView!
    
    //MARK: - Variables
    var usernameField: MDCTextInputController?
    var bioField: MDCMultilineTextField?
    var multiTextController: MDCTextInputController?
    var selectedImage: UIImage? = nil
    var currentUser: User? = nil
    var validInput = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        profilePicContainer.layer.cornerRadius = profilePicContainer.bounds.width / 2
        profilePicContainer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:))))
        setupMaterialComponents()
        currentUser = UserDefaultsUtil().loadUserData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Storyboard Actions
    func imageTapped(_ sender: UIView){
        let fusama = FusumaViewController()
        fusama.delegate = self
        present(fusama, animated: true, completion: nil)
    }
    
    func doneTapped(_ sender: UIBarButtonItem){
        if validInput{
            onValid()
        }
    }
    
    
    //MARK: - Text Field Callbacks
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let textf = textField as? MDCTextInput{
            if (textf.text?.isEmpty)!{
                validInput = false
                usernameField?.setErrorText("Must have a username", errorAccessibilityValue: nil)
            }else{
                validInput = true
                checkUsername(textf.text!)
            }
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        usernameField?.setErrorText(nil, errorAccessibilityValue: nil)
    }
    
    //MARK: - Methods
    func setupMaterialComponents(){
        // Textfield
        usernameInput.placeholder = "Username"
        usernameField = MDCTextInputControllerDefault(textInput: usernameInput)
        usernameField?.activeColor = MDCPalette.blue.tint500
        bioField = MDCMultilineTextField()
        bioFieldContainer.addSubview(bioField!)
        bioField?.frame = bioFieldContainer.bounds
        bioField?.placeholder = "Bio"
        multiTextController = MDCTextInputControllerDefault(textInput: bioField)
        multiTextController?.activeColor = MDCPalette.blue.tint500
        
        // AppBar Setup
        let appBar = MDCAppBar()
        self.addChildViewController(appBar.headerViewController)
        appBar.headerViewController.headerView.backgroundColor = MDCPalette.grey.tint100
        appBar.navigationBar.tintColor = MDCPalette.blueGrey.tint900
        title = "Profile Setup"
        let doneAction = UIBarButtonItem(image: UIImage(named: "done")?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(doneTapped(_:)))
        doneAction.tintColor = UIColor.black
        navigationItem.rightBarButtonItems = [doneAction]
        appBar.addSubviewsToParent()
    }
    
    func onValid(){
        if selectedImage != nil{
            progressView.isHidden = false
            bioField?.isEnabled = false
            view.isUserInteractionEnabled = false
            saveImage(selectedImage!)
        } else{
            uploadComplete()
        }
    }
    
    func uploadComplete(){
        if !(usernameInput?.text?.isEmpty)!{
            currentUser?.username = (usernameInput?.text)!
            currentUser?.bio = (bioField?.text)!
            UserDefaultsUtil().saveUserData(currentUser!)
        }
        
        DatabaseUtil().createUser(currentUser!)
        performSegue(withIdentifier: "toFeed", sender: self)
    }
    
    func checkUsername(_ username: String){
        let db = Firestore.firestore()
        db.collection("users").whereField("username", isEqualTo: username).getDocuments { (snapshot, error) in
            if (snapshot?.documents.isEmpty)!{
                self.usernameField?.setErrorText(nil, errorAccessibilityValue: nil)
                self.validInput = true
                self.onValid()
                return
            }
            self.validInput = true
            
            for i in (snapshot?.documents)!{
                let nameToCheck = i.data()["username"] as! String
                if nameToCheck == username{
                    // Username is taken
                    self.usernameField?.setErrorText("Username is taken", errorAccessibilityValue: nil)
                    self.validInput = false
                    return
                }
            }
            
            if self.validInput{
                self.onValid()
            }
        }
    }
    
    //MARK: - Fusama Callbacks
    func fusumaImageSelected(_ image: UIImage, source: FusumaMode) {
        selectedImage = image
        
    }
    
    func fusumaMultipleImageSelected(_ images: [UIImage], source: FusumaMode) {
        
    }
    
    func fusumaVideoCompleted(withFileURL fileURL: URL) {
        
    }
    
    func fusumaCameraRollUnauthorized() {
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension ProfileSetupViewController{
    func saveImage(_ image: UIImage){
        var downloadUrl: String = ""
        var imageData: Data? = nil
        let user = UserDefaultsUtil().loadUserData()
        var format = DateFormatter()
        let storageRef = Storage.storage().reference()
        format.dateFormat = "yyyyMMddHHmmss"
        
        var imageRefString = "images/\(UserDefaultsUtil().loadReference())" + format.string(from: Date())
        var imageRef: StorageReference? = nil
        
        // Convert to data
        if let jpeg = image.jpegImg{
            imageData = jpeg
            imageRefString = imageRefString + ".jpg"
            imageRef = storageRef.child(imageRefString)
        }else if let png = image.pngImg{
            imageData = png
            imageRefString = imageRefString + ".png"
            imageRef = storageRef.child(imageRefString)
        }
        
        let uploadTask = imageRef?.putData(imageData!, metadata: nil, completion: { (metaData, error) in
            guard let metaData = metaData else{
                // Error
                return
            }
            if let error = error{
                // Error
                print(error.localizedDescription)
            }
            
            
            //post.setImageUrl((metaData.downloadURL()?.absoluteString)!)
        })
        uploadTask?.observe(.progress, handler: { (snapshot) in
            // Progress
            
            var percent = (snapshot.progress?.fractionCompleted)!
            percent = round(100*percent)/100

            DispatchQueue.main.async {
                self.progressView.progress = Float(percent)
            }
        })
        uploadTask?.observe(.success, handler: { (snapshot) in
            
            user.profilePicUrl = (snapshot.metadata?.downloadURL()?.absoluteString)!
            UserDefaultsUtil().saveUserData(user)
            DispatchQueue.main.async {
                uploadTask?.removeAllObservers(for: .progress)
                self.uploadComplete()
            }
        })
        
    }
}
