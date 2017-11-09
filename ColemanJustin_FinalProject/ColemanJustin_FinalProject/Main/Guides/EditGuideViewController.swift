//
//  EditGuideViewController.swift
//  ColemanJustin_FinalProject
//
//  Created by Justin Coleman on 10/27/17.
//  Copyright © 2017 Justin Coleman. All rights reserved.
//

import UIKit
import MaterialComponents
import Fusuma
import Firebase

class EditGuideViewController: UIViewController, UITextFieldDelegate, FusumaDelegate {

    //MARK: - Outlets
    @IBOutlet weak var imageContainer: UIView!
    @IBOutlet weak var guideImage: UIImageView!
    @IBOutlet weak var textInputContainer: UIView!
    @IBOutlet weak var titleInput: MDCTextField!
    @IBOutlet weak var productsBtn: MDCRaisedButton!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    //MARK: - Variables
    var textController: MDCTextInputController?
    var multiTextController: MDCTextInputController?
    var textInput: MDCMultilineTextField?
    var editGuide: Guide?
    var selectedImage: UIImage? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.navigationController?.setToolbarHidden(true, animated: true)
        setupMaterialComponents()
        imageContainer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:))))
        if !(editGuide?.mImageUrl.isEmpty)!{
            
        }
        guideImage.pin_updateWithProgress = true
        guideImage.pin_setImage(from: URL(string: (editGuide?.mImageUrl)!))
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Storyboard Actions
    func doneTapped(_ sender: UIBarButtonItem){
        
        if !titleInput.text!.isEmpty && !(textInput?.text?.isEmpty)!{
            textController?.setErrorText(nil, errorAccessibilityValue: nil)
            editGuide?.mTitle = titleInput.text!
            editGuide?.mText = (textInput?.text)!
            if (selectedImage != nil){
                progressView.isHidden = false
                view.isUserInteractionEnabled = false
                saveImage(selectedImage!)
            }else{
                uploadComplete()
            }
            
        } else{
            textController?.setErrorText("Must have a title", errorAccessibilityValue: nil)
            multiTextController?.setErrorText("Must have guide text", errorAccessibilityValue: nil)
        }
    }
    
    func deleteTapped(_ sender: UIBarButtonItem){
        let alert = UIAlertController(title: "Delete Guide", message: "Are you sure you want to delete this guide? Once it is deleted it is gone forever.", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: .default) { (action) in
            self.deleteGuide(self.editGuide!)
        }
        let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        alert.addAction(yesAction)
        alert.addAction(noAction)
        present(alert, animated: true, completion: nil)
    }
    
    func imageTapped(_ sender: UIBarButtonItem){
        let fusama = FusumaViewController()
        fusama.delegate = self
        present(fusama, animated: true, completion: nil)
    }
    
    //MARK: - Methods
    func setupMaterialComponents(){
        
        // TextField
        titleInput.placeholder = "Title"
        textController = MDCTextInputControllerDefault(textInput: titleInput)
        textController?.activeColor = MDCPalette.blue.tint500
        titleInput.text = editGuide?.mTitle
        
        textInput = MDCMultilineTextField()
        textInputContainer.addSubview(textInput!)
        textInput?.frame = textInputContainer.bounds
        textInput?.placeholder = "Text"
        textInput?.text = editGuide?.mText
        multiTextController = MDCTextInputControllerDefault(textInput: textInput)
        multiTextController?.activeColor = MDCPalette.blue.tint500
        
        productsBtn.setBackgroundColor(MDCPalette.blue.tint500, for: .normal)
        productsBtn.setImage(UIImage(named: "product")?.withRenderingMode(.alwaysTemplate), for: .normal)
        productsBtn.tintColor = UIColor.white
        productsBtn.setTitle("", for: .normal)
        
        // AppBar Setup
        let appBar = MDCAppBar()
        self.addChildViewController(appBar.headerViewController)
        appBar.headerViewController.headerView.clipsToBounds = false
        appBar.headerViewController.headerView.layer.shadowOffset = CGSize(width: 0, height: 1)
        appBar.headerViewController.headerView.layer.shadowOpacity = 0.3
        appBar.headerViewController.headerView.layer.shadowRadius = 3
        appBar.headerViewController.headerView.backgroundColor = UIColor.white
        appBar.navigationBar.tintColor = MDCPalette.blueGrey.tint900
        title = "Edit Guide"
        let doneAction = UIBarButtonItem(image: UIImage(named: "done")?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(doneTapped(_:)))
        doneAction.tintColor = UIColor.black
        let deleteAction = UIBarButtonItem(image: UIImage(named: "delete")?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(deleteTapped(_:)))
        deleteAction.tintColor = UIColor.black
        navigationItem.rightBarButtonItems = [doneAction, deleteAction]
        appBar.addSubviewsToParent()
    }
    
    func uploadComplete(){
        DatabaseUtil().updateGuide(editGuide!)
        performSegue(withIdentifier: "toEditGuide", sender: self)
    }
    
    func deleteGuide(_ guide: Guide){
        let db = Firestore.firestore()
        db.collection("guides").document((editGuide?.mReference)!).delete { (error) in
            if error != nil{
                print(error?.localizedDescription)
                return
            }
            
            self.performSegue(withIdentifier: "toEditGuide", sender: self)
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
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.destination as? GuidesViewController != nil{
            let vc = segue.destination as! GuidesViewController
            //vc.createdGuide = newGuide
        }
    }
    
    
}

extension EditGuideViewController{
    func saveImage(_ image: UIImage){
        var downloadUrl: String = ""
        var imageData: Data? = nil
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
        let metaData = StorageMetadata(dictionary: ["contentType" : "image/jpg"])
        let uploadTask = imageRef?.putData(imageData!, metadata: metaData, completion: { (metaData, error) in
            guard let metaData = metaData else{
                // Error
                return
            }
            if let error = error{
                // Error
                print(error.localizedDescription)
            }
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
            
            self.editGuide?.mImageUrl = (snapshot.metadata?.downloadURL()?.absoluteString)!
            DispatchQueue.main.async {
                uploadTask?.removeAllObservers(for: .progress)
                self.uploadComplete()
            }
        })
        
    }
}
