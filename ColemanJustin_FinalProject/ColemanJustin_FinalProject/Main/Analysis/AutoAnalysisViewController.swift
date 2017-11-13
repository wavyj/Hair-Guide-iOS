//
//  AutoAnalysisViewController.swift
//  ColemanJustin_FinalProject
//
//  Created by Justin Coleman on 10/28/17.
//  Copyright © 2017 Justin Coleman. All rights reserved.
//

import UIKit
import MaterialComponents
import VisualRecognitionV3
import Firebase
import ImagePicker

class AutoAnalysisViewController: UIViewController, ImagePickerDelegate {
    
    //MARK: - Outlets
    @IBOutlet weak var selectedImage: UIImageView!
    @IBOutlet weak var hairType: UILabel!
    @IBOutlet weak var hairPattern: UILabel!
    @IBOutlet weak var continueBtn: MDCRaisedButton!
    @IBOutlet weak var progressView: UIActivityIndicatorView!
    
    //MARK: - Variables
    let watsonUrl = "https://gateway-a.watsonplatform.net/visual-recognition/api"
    let key = "cf4dc17fd1bcbabfd2a9bc399a4511a6e629ad5f"
    let version = "2017-10-28"
    var visualRecognition: VisualRecognition?
    var positives = [PositiveExample]()
    let negatives = "https://firebasestorage.googleapis.com/v0/b/final-project-af0ee.appspot.com/o/analysis%2Fnegative%2FNegative%20Examples.zip?alt=media&token=8890b88e-168e-442b-84d6-f37c9ecd7b37"
    var classifier: Classifier? = nil
    let classifierID = "hairType_1115685452"
    let classifierOwner = "56ca71ef-2e71-4838-82bb-0d4c1d1e9c71"
    var resultHairType = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        visualRecognition = VisualRecognition(apiKey: key, version: version)
        addPositives()
        setupMaterialComponents()
        //createClassifyer()
        selectedImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:))))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: - Storyboard Actions
    @objc func imageTapped(_ sender: UIImageView){
        var config = Configuration()
        config.doneButtonTitle = "Done"
        config.noImagesTitle = "Sorry! No images found"
        config.recordLocation = false
        config.allowMultiplePhotoSelection = false
        config.allowVideoSelection = false
        
        let imagePicker = ImagePickerController(configuration: config)
        imagePicker.imageLimit = 1
        //imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func continueTapped(_ sender: MDCRaisedButton){
        performSegue(withIdentifier: "toAnalysisDetails", sender: self)
    }
    
    
    //MARK: - Methods
    func setupMaterialComponents(){
        //Button
        continueBtn.setBackgroundColor(MDCPalette.blue.tint500, for: .normal)
        continueBtn.setTitle("Details", for: .normal)
        continueBtn.setTitleColor(UIColor.black, for: .normal)
        continueBtn.addTarget(self, action: #selector(continueTapped(_:)), for: .touchUpInside)
        
        // AppBar Setup
        let appBar = MDCAppBar()
        self.addChildViewController(appBar.headerViewController)
        appBar.headerViewController.headerView.clipsToBounds = false
        appBar.headerViewController.headerView.layer.shadowOffset = CGSize(width: 0, height: 1)
        appBar.headerViewController.headerView.layer.shadowOpacity = 0.3
        appBar.headerViewController.headerView.layer.shadowRadius = 3
        appBar.headerViewController.headerView.backgroundColor = UIColor.white
        appBar.navigationBar.tintColor = MDCPalette.blueGrey.tint900
        title = "Hair Analysis"
        appBar.addSubviewsToParent()
    }
    
    func createClassifier(){
        visualRecognition?.createClassifier(withName: "hairType", positiveExamples: positives, negativeExamples: URL(string: negatives), failure: { (error) in
            print(error.localizedDescription)
            return
        }, success: { (returnedClassifier) in
            self.classifier = returnedClassifier
        })
    }
    
    func classify(_ url: String){
        visualRecognition?.classify(imageFile: URL(string: url)!, owners: [classifierOwner], classifierIDs: [classifierID], threshold: 0.5, language: "en", failure: { (error) in
            if error != nil{
                print(error.localizedDescription)
            }
        }, success: { (images) in
            //print(images)
            let sorted = images.images.first?.classifiers.first?.classes.sorted(by: { (c1, c2) -> Bool in
                return c1.score > c2.score
            })
            DispatchQueue.main.async {
                self.hairPattern.text = sorted?.first?.classification
                self.hairPattern.isHidden = false
                self.resultHairType = self.hairPattern.text!
                
                let pattern = self.hairPattern.text
                if (pattern?.contains("1"))!{
                    self.hairType.text = "Stright"
                }else if (pattern?.contains("2"))!{
                    self.hairType.text = "Wavy"
                }else if (pattern?.contains("3"))!{
                    self.hairType.text = "Curly"
                }else{
                    self.hairType.text = "Kinky"
                }
                self.hairType.isHidden = false
                self.continueBtn.isHidden = false
                self.progressView.stopAnimating()
                
            }
            
            let u = UserDefaultsUtil().loadUserData()
            u.hairTypes.append((sorted?.first?.classification)!)
            UserDefaultsUtil().saveUserData(u)
        })
        
    }
    
    func addPositives(){
        let twoA = PositiveExample(name: "2A", examples: URL(string: "https://firebasestorage.googleapis.com/v0/b/final-project-af0ee.appspot.com/o/analysis%2Fpositive%2F2A.zip?alt=media&token=8def28b4-c4a8-4fda-bdac-5d998c7e3024")!)
        let twoB = PositiveExample(name: "2B", examples: URL(string: "https://firebasestorage.googleapis.com/v0/b/final-project-af0ee.appspot.com/o/analysis%2Fpositive%2F2B.zip?alt=media&token=62066bf2-60d9-46b6-a21b-9902a149cbfd")!)
        let twoC = PositiveExample(name: "2C", examples: URL(string: "https://firebasestorage.googleapis.com/v0/b/final-project-af0ee.appspot.com/o/analysis%2Fpositive%2F2C.zip?alt=media&token=da941960-3716-4aad-92aa-2526bc71658c")!)
        let threeA = PositiveExample(name: "3A", examples: URL(string: "https://firebasestorage.googleapis.com/v0/b/final-project-af0ee.appspot.com/o/analysis%2Fpositive%2F3A.zip?alt=media&token=7a544b73-97da-4eeb-ae41-0d182a76bf5b")!)
        let threeB = PositiveExample(name: "3B", examples: URL(string: "https://firebasestorage.googleapis.com/v0/b/final-project-af0ee.appspot.com/o/analysis%2Fpositive%2F3B.zip?alt=media&token=0aa971ca-1912-4656-a4fe-a75004088628")!)
        let threeC = PositiveExample(name: "3C", examples: URL(string: "https://firebasestorage.googleapis.com/v0/b/final-project-af0ee.appspot.com/o/analysis%2Fpositive%2F3C.zip?alt=media&token=450202af-046d-4733-896c-2d5eacd29824")!)
        let fourA = PositiveExample(name: "4A", examples: URL(string: "https://firebasestorage.googleapis.com/v0/b/final-project-af0ee.appspot.com/o/analysis%2Fpositive%2F4A.zip?alt=media&token=4c9e67a0-cd92-4a60-a000-41d3d05d081d")!)
        let fourB = PositiveExample(name: "4B", examples: URL(string: "https://firebasestorage.googleapis.com/v0/b/final-project-af0ee.appspot.com/o/analysis%2Fpositive%2F4B.zip?alt=media&token=e7eac270-0c32-42b2-b957-30a211854ba8")!)
        let fourC = PositiveExample(name: "4C", examples: URL(string: "https://firebasestorage.googleapis.com/v0/b/final-project-af0ee.appspot.com/o/analysis%2Fpositive%2F4C.zip?alt=media&token=f95e10af-52b2-4dd1-b12b-c070e3a8f6bb")!)
        let oneA = PositiveExample(name: "1A", examples: URL(string: "https://firebasestorage.googleapis.com/v0/b/final-project-af0ee.appspot.com/o/analysis%2Fpositive%2FStraight.zip?alt=media&token=a899db51-b02d-4f67-bd56-15ba5c2bd7d7")!)
        
        positives = [oneA, twoA, twoB, twoC, threeA, threeB, threeC, fourA, fourB, fourC]
    }
    
     //MARK: - ImagePicker Delegate Callbacks
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        imagePicker.dismiss(animated: true, completion: nil)
        selectedImage.image = images.first!
        self.view.isUserInteractionEnabled = false
        progressView.isHidden = false
        progressView.startAnimating()
        saveImage(images.first!)
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
        if let vc = segue.destination as? AnalysisDetailsViewController{
            vc.hairPattern = resultHairType
        }
    }
 

}
extension AutoAnalysisViewController{
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
            if let error = error{
                // Error
                print(error.localizedDescription)
            }
       
        })
        uploadTask?.observe(.success, handler: { (snapshot) in
            uploadTask?.removeAllObservers(for: .progress)
            
            DispatchQueue.main.async {
                self.view.isUserInteractionEnabled = true
                self.classify((snapshot.metadata?.downloadURL()?.absoluteString)!)
            }
        })
        
    }
 }
