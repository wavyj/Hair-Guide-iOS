//
//  NewGuideViewController.swift
//  ColemanJustin_FinalProject
//
//  Created by Justin Coleman on 10/15/17.
//  Copyright © 2017 Justin Coleman. All rights reserved.
//

import UIKit
import MaterialComponents
import Firebase
import ImagePicker

class NewGuideViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, ImagePickerDelegate {
    
    //MARK: - Outlets
    //@IBOutlet weak var editor: UIView!
    //@IBOutlet weak var editorBar: UIView!
    @IBOutlet weak var imageContainer: UIView!
    @IBOutlet weak var guideImage: UIImageView!
    @IBOutlet weak var textInputContainer: UIView!
    @IBOutlet weak var titleInput: MDCTextField!
    @IBOutlet weak var productsBtn: MDCRaisedButton!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var productsCollectionView: UICollectionView!

    //MARK: - Variables
    var textController: MDCTextInputController?
    var multiTextController: MDCTextInputController?
    var textInput: MDCMultilineTextField?
    var newGuide: Guide? = nil
    var selectedImage: UIImage? = nil
    var products = [Product]()
    
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
    @IBAction func onProductAdd(_ sender: UIStoryboardSegue){
        productsCollectionView.reloadData()
    }
    
    @objc func doneTapped(_ sender: UIBarButtonItem){
    
        if !titleInput.text!.isEmpty && !(textInput?.text?.isEmpty)!{
            textController?.setErrorText(nil, errorAccessibilityValue: nil)
            newGuide = Guide(title: titleInput.text!, text: (textInput?.text)!, viewCount: 0, comments: 0)
            newGuide?.mProducts = products
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
    
    @objc func imageTapped(_ sender: UIBarButtonItem){
        var config = Configuration()
        config.doneButtonTitle = "Done"
        config.noImagesTitle = "Sorry! No images found"
        config.recordLocation = false
        config.allowMultiplePhotoSelection = false
        config.allowVideoSelection = false
        
        let imagePicker = ImagePickerController(configuration: config)
        imagePicker.imageLimit = 1
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func productTapped(_ sender: MDCRaisedButton){
        performSegue(withIdentifier: "toAddProduct", sender: self)
    }
    
    //MARK: - Methods
    func setupMaterialComponents(){
        let nib = UINib(nibName: "ProductGridCell", bundle: nil)
        productsCollectionView?.register(nib, forCellWithReuseIdentifier: "productCell")
        
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
        self.addChildViewController((appBar.headerViewController))
        appBar.headerViewController.headerView.clipsToBounds = false
        appBar.headerViewController.headerView.layer.shadowOffset = CGSize(width: 0, height: 1)
        appBar.headerViewController.headerView.layer.shadowOpacity = 0.3
        appBar.headerViewController.headerView.layer.shadowRadius = 3
        appBar.headerViewController.headerView.backgroundColor = UIColor.white
        appBar.navigationBar.tintColor = MDCPalette.blueGrey.tint900
        title = "New Guide"
        let doneAction = UIBarButtonItem(image: UIImage(named: "done")?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(doneTapped(_:)))
        
        navigationItem.rightBarButtonItem = doneAction
        appBar.addSubviewsToParent()
    }
    
    func uploadComplete(){
        DatabaseUtil().createGuide(newGuide!)
        performSegue(withIdentifier: "toNewGuide", sender: self)
    }
    
    //MARK: - CollectionView Callbacks
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productCell", for: indexPath) as! ProductGridCell
        let selected = products[indexPath.row]
        cell.priceLabel.text = selected.getPrice
        cell.productImage.pin_setImage(from: URL(string: selected.imageUrl))
        cell.productImage.pin_updateWithProgress = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toAddProduct", sender: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width * 0.25, height: collectionView.bounds.height * 0.9)
    }
    
    //MARK: - ImagePicker Delegate Callbacks
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        selectedImage = images.first!
        guideImage.image = images.first!
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        
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
        
        if let vc = segue.destination as? ProductSearchViewController {
            vc.selectedProducts = products
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
