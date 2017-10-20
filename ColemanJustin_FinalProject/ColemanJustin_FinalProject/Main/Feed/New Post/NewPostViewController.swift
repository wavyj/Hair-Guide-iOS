//
//  CameraViewController.swift
//  ColemanJustin_FinalProject
//
//  Created by Justin Coleman on 10/14/17.
//  Copyright © 2017 Justin Coleman. All rights reserved.
//

import UIKit
import MaterialComponents
import Fusuma

class NewPostViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate {
    
    //MARK: - Outlets
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var captionField: MDCTextField!
    @IBOutlet weak var submitBtn: MDCRaisedButton!
    @IBOutlet weak var tagsView: UICollectionView!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    //MARK: - Variables
    var newPost: Post? = nil
    var currentImage: UIImage? = nil
    var textViewController: MDCTextInputController? = nil
    var tags: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        postImage.image = currentImage
        setupMaterialComponents()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Storyboard Actions
    func backTapped(_ sender: UIBarButtonItem){
        performSegue(withIdentifier: "unwindFeed", sender: self)
    }
    
    func submitTapped(_ sender: UIButton){
        // Create Post
        newPost = Post(caption: captionField!.text!, image: currentImage!, likes: 20, comments: 5)
        newPost?.mTags = tags
        
        // Upload Image
        CloudStorageUtil(self).saveImage((newPost?.mImage)!, newPost!)
        progressView.isHidden = false
        spinner.isHidden = false
        submitBtn.isEnabled = false
        captionField.isEnabled = false
        tagsView.isUserInteractionEnabled = false
    }
    
    func addTapped(_ sender: MDCRaisedButton){
        tags.append("Curly")
        tagsView.reloadData()
    }
    
    //MARK: - CollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return tags.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0{
            // Add Button
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "addCell", for: indexPath) as! AddTagCell
            cell.addBtn.setBackgroundColor(MDCPalette.grey.tint300, for: .normal)
            cell.addBtn.addTarget(self, action: #selector(addTapped(_:)), for: .touchUpInside)
            cell.addBtn.setImage(UIImage(named: "add")?.withRenderingMode(.alwaysTemplate), for: .normal)
            cell.addBtn.tintColor = UIColor.white
            cell.addBtn.setBackgroundColor(MDCPalette.blue.tint500, for: .normal)
            cell.addBtn.setTitle("", for: .normal)
            return cell
            
        } else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! TagCell
            cell.tagText.text = tags[indexPath.row]
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section > 0{
            let alert = UIAlertController(title: "Remove Tag?", message: "", preferredStyle: .alert)
            let yesAction = UIAlertAction(title: "Yes", style: .default, handler: { (action) in
                self.tags.remove(at: indexPath.section - 1)
                collectionView.reloadData()
            })
            let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
            alert.addAction(yesAction)
            alert.addAction(noAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK: - Methods
    func setupMaterialComponents(){
        
        submitBtn.setBackgroundColor(MDCPalette.blue.tint500, for: .normal)
        submitBtn.setTitle("Submit", for: .normal)
        submitBtn.setTitleColor(UIColor.white, for: .normal)
        submitBtn.addTarget(self, action: #selector(submitTapped(_:)), for: .touchUpInside)
        
        captionField.delegate = self
        captionField.placeholder = "Caption"
        textViewController = MDCTextInputControllerDefault(textInput: captionField)
        textViewController?.activeColor = MDCPalette.blue.tint500
        
        // AppBar Setup
        let appBar = MDCAppBar()
        self.addChildViewController(appBar.headerViewController)
        appBar.headerViewController.headerView.backgroundColor = MDCPalette.grey.tint100
        appBar.navigationBar.tintColor = MDCPalette.blueGrey.tint900
        title = "New Post"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back-arrow"), style: .plain, target: self, action: #selector(backTapped(_:)))
        appBar.addSubviewsToParent()
    }
    
    func uploadComplete(){
        performSegue(withIdentifier: "unwindNewPost", sender: self)
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.destination as? FeedViewController != nil{
            let vc = segue.destination as! FeedViewController
            vc.addedPost = newPost
        }
    }
 

}
