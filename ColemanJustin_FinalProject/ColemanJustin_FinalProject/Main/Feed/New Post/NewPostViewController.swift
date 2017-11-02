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
        self.navigationController?.setToolbarHidden(true, animated: false)
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
        newPost = Post(caption: captionField!.text!, image: currentImage!, likes: 0, comments: 0)
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
        performSegue(withIdentifier: "toAddTag", sender: self)
    }
    
    @IBAction func newTags(_ sender: UIStoryboardSegue){
        tagsView.reloadData()
    }
    
    @IBAction func unwindTags(_ sender: UIStoryboardSegue){
        
    }
    
    func tagTapped(_ sender: MDCRaisedButton){
        let alert = UIAlertController(title: "Remove \(tags[sender.tag])?", message: "", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            self.tags.remove(at: sender.tag)
            self.tagsView.reloadData()
        })
        let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        alert.addAction(yesAction)
        alert.addAction(noAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - CollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count + 1
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tagCell", for: indexPath) as! TagCell
        if indexPath.row == 0{
            // Add Button
            cell.tagBtn.addTarget(self, action: #selector(addTapped(_:)), for: .touchUpInside)
            cell.tagBtn.setImage(UIImage(named: "add")?.withRenderingMode(.alwaysTemplate), for: .normal)
            cell.tagBtn.tintColor = UIColor.white
            cell.tagBtn.setBackgroundColor(MDCPalette.blue.tint500, for: .normal)
            cell.tagBtn.setTitle("", for: .normal)
            
        } else{
            cell.tagBtn.addTarget(self, action: #selector(tagTapped(_:)), for: .touchUpInside)
            cell.tagBtn.setBackgroundColor(MDCPalette.grey.tint100, for: .normal)
            cell.tagBtn.setTitle(tags[indexPath.row - 1], for: .normal)
            cell.tagBtn.setTitleColor(UIColor.black, for: .normal)
            cell.tagBtn.tag = indexPath.row - 1
        }
        return cell
    }
    
    //MARK: - TextView Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
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
        
        if let vc = segue.destination as? TagsViewController {
            vc.selectedTags = tags
        }
    }
 

}
