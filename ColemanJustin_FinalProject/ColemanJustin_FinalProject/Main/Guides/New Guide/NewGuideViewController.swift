//
//  NewGuideViewController.swift
//  ColemanJustin_FinalProject
//
//  Created by Justin Coleman on 10/15/17.
//  Copyright © 2017 Justin Coleman. All rights reserved.
//

import UIKit
import MaterialComponents
import Fusuma
import Firebase

class NewGuideViewController: /*WPEditorViewController, WPEditorViewControllerDelegate, WPEditorViewDelegate*/ UIViewController, FusumaDelegate {
    
    //MARK: - Outlets
    //@IBOutlet weak var editor: UIView!
    //@IBOutlet weak var editorBar: UIView!
    @IBOutlet weak var imageContainer: UIView!
    @IBOutlet weak var guideImage: UIImageView!
    @IBOutlet weak var textInputContainer: UIView!
    @IBOutlet weak var titleInput: MDCTextField!
    @IBOutlet weak var productsBtn: MDCRaisedButton!
    @IBOutlet weak var progressView: UIProgressView!

    //MARK: - Variables
    var textController: MDCTextInputController?
    var multiTextController: MDCTextInputController?
    var textInput: MDCMultilineTextField?
    var newGuide: Guide? = nil
    var selectedImage: UIImage? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.setToolbarHidden(true, animated: true)
        setupMaterialComponents()
        imageContainer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:))))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Storyboard Actions
    func doneTapped(_ sender: UIBarButtonItem){
    
        if !titleInput.text!.isEmpty && !(textInput?.text?.isEmpty)!{
            textController?.setErrorText(nil, errorAccessibilityValue: nil)
            newGuide = Guide(title: titleInput.text!, text: (textInput?.text)!, viewCount: 0, comments: 0)
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
    
    func imageTapped(_ sender: UIBarButtonItem){
        let fusama = FusumaViewController()
        fusama.delegate = self
        present(fusama, animated: true, completion: nil)
    }
    
    func productTapped(_ sender: MDCRaisedButton){
        performSegue(withIdentifier: "toAddProduct", sender: self)
    }
    
    //MARK: - Methods
    func setupMaterialComponents(){
        
        // TextField
        titleInput.placeholder = "Title"
        textController = MDCTextInputControllerDefault(textInput: titleInput)
        textController?.activeColor = MDCPalette.blue.tint500
        
        textInput = MDCMultilineTextField()
        textInputContainer.addSubview(textInput!)
        textInput?.frame = textInputContainer.bounds
        textInput?.placeholder = "Text"
        multiTextController = MDCTextInputControllerDefault(textInput: textInput)
        multiTextController?.activeColor = MDCPalette.blue.tint500
        
        productsBtn.setBackgroundColor(MDCPalette.blue.tint500, for: .normal)
        productsBtn.setTitle("Add Product", for: .normal)
        productsBtn.tintColor = UIColor.white
        productsBtn.addTarget(self, action: #selector(productTapped(_:)), for: .touchUpInside)

        // AppBar Setup
        let appBar = MDCAppBar()
        self.addChildViewController(appBar.headerViewController)
        appBar.headerViewController.headerView.backgroundColor = MDCPalette.grey.tint100
        appBar.navigationBar.tintColor = MDCPalette.blueGrey.tint900
        title = "New Guide"
        let doneAction = UIBarButtonItem(image: UIImage(named: "done")?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(doneTapped(_:)))
        doneAction.tintColor = UIColor.black
        navigationItem.rightBarButtonItems = [doneAction]
        appBar.addSubviewsToParent()
    }
    
    func uploadComplete(){
        DatabaseUtil().createGuide(newGuide!)
        performSegue(withIdentifier: "toNewGuide", sender: self)
    }
    
    //MARK: - Fusama Callbacks
    func fusumaImageSelected(_ image: UIImage, source: FusumaMode) {
        selectedImage = image
        guideImage.image = image
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

extension NewGuideViewController{
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
        
        let uploadTask = imageRef?.putData(imageData!, metadata: nil, completion: { (metaData, error) in
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
            
            self.newGuide?.mImageUrl = (snapshot.metadata?.downloadURL()?.absoluteString)!
            DispatchQueue.main.async {
                uploadTask?.removeAllObservers(for: .progress)
                self.uploadComplete()
            }
        })
        
    }
}
