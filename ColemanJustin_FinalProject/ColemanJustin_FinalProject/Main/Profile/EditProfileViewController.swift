//
//  EditProfileViewController.swift
//  ColemanJustin_FinalProject
//
//  Created by Justin Coleman on 10/25/17.
//  Copyright © 2017 Justin Coleman. All rights reserved.
//

import UIKit
import MaterialComponents
import ImageButter
import Fusuma
import Firebase

class EditProfileViewController: UIViewController, UITextFieldDelegate, FusumaDelegate {
    
    //MARK: - Outlets
    @IBOutlet weak var profilePicContainer: UIView!
    @IBOutlet weak var profilePic: WebPImageView!
    @IBOutlet weak var usernameField: MDCTextField!
    @IBOutlet weak var bioFieldContainer: UIView!
    @IBOutlet weak var progressView: UIProgressView!
    
    //MARK: - Variables
    var currentUser: User? = nil
    var bioField: MDCMultilineTextField?
    var textController: MDCTextInputController? = nil
    var multiTextController: MDCTextInputController?
    var selectedImage: UIImage? = nil
    var validInputs = true

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.setToolbarHidden(true, animated: false)
        
        profilePicContainer.layer.cornerRadius = profilePicContainer.bounds.width / 2
        profilePicContainer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:))))
        currentUser = UserDefaultsUtil().loadUserData()
        setupMaterialComponents()
        profilePic.url = URL(string: (currentUser?.profilePicUrl)!)
        let loadingView = WebPLoadingView()
        loadingView.lineColor = MDCPalette.blue.tint500
        loadingView.lineWidth = 2
        profilePic.loadingView = loadingView
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Storyboard Actions
    func doneTapped(_ sender: UIBarButtonItem){
        if selectedImage != nil{
            progressView.isHidden = false
            self.view.isUserInteractionEnabled = false
            CloudStorageUtil(self).saveImage(selectedImage!, nil)
        }else{
            if !(usernameField.text?.isEmpty)!{
                currentUser?.username = usernameField.text!
                currentUser?.bio = (bioField?.text)!
                checkUsername((currentUser?.username)!)
                if validInputs{
                    UserDefaultsUtil().saveUserData((currentUser)!)
                    DatabaseUtil().updateUser(currentUser!)
                    performSegue(withIdentifier: "unwindProfile", sender: self)
                }
            }else{
                validInputs = false
                
            }
        }
    }
    @IBAction func imageTapped(_ sender: UIView){
        let fusama = FusumaViewController()
        fusama.delegate = self
        present(fusama, animated: true, completion: nil)
    }
    
    //MARK: - Methods
    func setupMaterialComponents(){
        
        // TextField
        usernameField.placeholder = "Username"
        usernameField.text = currentUser?.username
        textController = MDCTextInputControllerDefault(textInput: usernameField)
        textController?.activeColor = MDCPalette.blue.tint500
        
        bioField = MDCMultilineTextField()
        bioFieldContainer.addSubview(bioField!)
        bioField?.frame = bioFieldContainer.bounds
        bioField?.placeholder = "Bio"
        bioField?.text = currentUser?.bio
        multiTextController = MDCTextInputControllerDefault(textInput: bioField)
        multiTextController?.activeColor = MDCPalette.blue.tint500
        
        // AppBar Setup
        let appBar = MDCAppBar()
        self.addChildViewController(appBar.headerViewController)
        appBar.headerViewController.headerView.backgroundColor = MDCPalette.grey.tint100
        appBar.navigationBar.tintColor = MDCPalette.blueGrey.tint900
        title = "Edit Profile"
        let doneAction = UIBarButtonItem(image: UIImage(named: "done")?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(doneTapped(_:)))
        doneAction.tintColor = UIColor.black
        navigationItem.rightBarButtonItems = [doneAction]
        appBar.addSubviewsToParent()
    }
    
    func uploadComplete(){
        currentUser = UserDefaultsUtil().loadUserData()
        if validInputs{
        DatabaseUtil().updateUser(currentUser!)
        performSegue(withIdentifier: "unwindProfile", sender: self)
        }
    }
    
    func checkUsername(_ username: String){
        let db = Firestore.firestore()
        db.collection("users").whereField("username", isEqualTo: username).getDocuments { (snapshot, error) in
            if (snapshot?.documents.isEmpty)!{
                self.textController?.setErrorText(nil, errorAccessibilityValue: nil)
                self.validInputs = true
                return
            }
            
            for i in (snapshot?.documents)!{
                let nameToCheck = i.data()["username"] as! String
                if nameToCheck == username && nameToCheck != self.currentUser?.username{
                    // Username is taken
                    self.textController?.setErrorText("Username is taken", errorAccessibilityValue: nil)
                    self.validInputs = false
                }else{
                    self.textController?.setErrorText(nil, errorAccessibilityValue: nil)
                    self.validInputs = true
                }
            }
        }
    }
    
    //MARK: - TextField Callbacks
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        if (textField.text?.isEmpty)!{
            textController?.setErrorText("Must have a username", errorAccessibilityValue: nil)
            return
        }else{
            textController?.setErrorText(nil, errorAccessibilityValue: nil)
        }
        checkUsername(textField.text!)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textController?.setErrorText(nil, errorAccessibilityValue: nil)
    }
    
    //MARK: - Fusama Callbacks
    func fusumaImageSelected(_ image: UIImage, source: FusumaMode) {
        selectedImage = image
        profilePic.image = WebPImage(image: image)
    }
    
    func fusumaMultipleImageSelected(_ images: [UIImage], source: FusumaMode) {
        
    }
    
    func fusumaVideoCompleted(withFileURL fileURL: URL) {
        
    }
    
    func fusumaCameraRollUnauthorized() {
        
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if let vc = segue.destination as? ProfileViewController{
            vc.currentUser = currentUser
        }
    }
 

}
