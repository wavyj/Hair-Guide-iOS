//
//  FeedViewController.swift
//  ColemanJustin_FinalProject
//
//  Created by Justin Coleman on 10/11/17.
//  Copyright © 2017 Justin Coleman. All rights reserved.
//

import UIKit
import MaterialComponents
import Fusuma
import IGListKit
import Firebase

class FeedViewController: UICollectionViewController, FusumaDelegate, UICollectionViewDelegateFlowLayout {
    
    //MARK: - Outlets
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    //MARK: - Variables
    var posts = [Post]()
    var selectedPost: Post? = nil
    var appBarHeight: CGFloat? = nil
    var transition: MDCMaskedTransition? = nil
    var selectedImage: UIImage? = nil
    var addedPost: Post? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationItem.setHidesBackButton(true, animated: false)
        setupMaterialComponents()
        //createPosts()
        loadPosts()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Storyboard Actions
    func cameraTapped(_ sender: UIBarButtonItem){
        addedPost = nil
        let fusama = FusumaViewController()
        fusama.delegate = self
        present(fusama, animated: true, completion: nil)
    }
    
    @IBAction func unwind(_ sender: UIStoryboardSegue){
        
    }
    
    @IBAction func newPost(_ sender: UIStoryboardSegue){
        if addedPost != nil{
            posts.append(addedPost!)
            collectionView?.reloadData()
        }
    }
    
    //MARK: - Collection View
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        if let cell = cell as? PostCell{
            let selected = posts[indexPath.row]
            if selected.mImage == nil{
                print("here")
                cell.butterDownloadImage(selected)
            } else{
                cell.butterSetImage(selected)
            }
            
            cell.likeBtn.setImage(UIImage(named: "like")?.withRenderingMode(.alwaysTemplate), for: .normal)
            cell.likeBtn.tintColor = MDCPalette.grey.tint400
            cell.commentBtn.setImage(UIImage(named: "comment")?.withRenderingMode(.alwaysTemplate), for: .normal)
            cell.commentBtn.tintColor = MDCPalette.grey.tint400
            cell.profileImg.layer.cornerRadius = cell.profileImg.frame.size.width / 2
            cell.timeLabel.text = selected.getDate()
            //cell.viewCommentsBtn.setTitle("View All 5 Comments", for: .normal)
            //cell.likesLabel.text = "20 Likes"
            //cell.applyVisuals()
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! PostCell
        
        selectedPost = posts[indexPath.row]
        
        performSegue(withIdentifier: "toSelectedProfile", sender: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        return CGSize(width: self.view.bounds.width, height: (self.collectionView?.bounds.height)! - 200)
    }
    
    //MARK: - Fusama Delegate Callbacks
    func fusumaImageSelected(_ image: UIImage, source: FusumaMode) {
        selectedImage = image
        performSegue(withIdentifier: "toNewPost", sender: self)
    }
    
    func fusumaMultipleImageSelected(_ images: [UIImage], source: FusumaMode) {
        // Do Nothing
    }
    
    func fusumaVideoCompleted(withFileURL fileURL: URL) {
        // Do Nothing
    }
    
    func fusumaCameraRollUnauthorized() {
        // Display Error
        
    }
    
    //MARK: - Methods
    func setupMaterialComponents(){
        
        appBarHeight = self.view.bounds.height * 0.1
        
        // AppBar Setup
        let appBar = MDCAppBar()
        self.addChildViewController(appBar.headerViewController)
        appBar.headerViewController.headerView.backgroundColor = MDCPalette.grey.tint100
        appBar.navigationBar.tintColor = MDCPalette.blueGrey.tint900
        title = "Feed"
        let cameraAction = UIBarButtonItem(image: UIImage(named: "cameraPlus")?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(cameraTapped(_:)))
        cameraAction.tintColor = UIColor.black
        navigationItem.rightBarButtonItem = cameraAction
        appBar.addSubviewsToParent()
    }
    
    func createPosts(){
        let first = Post(caption: "Me and my healthy curls", image: UIImage(named: "image1")!, likes: 20, comments: 2)
        let second = Post(caption: "Letting my hair breath at the beach", image: UIImage(named: "image3")!, likes: 48, comments: 5)
        let third = Post(caption: "Braided my hair. What you guys think?", image: UIImage(named: "image2")!, likes: 12, comments: 1)
        
        posts = [first, second, third]
    }
    
    func loadPosts(){
        let db = Firestore.firestore()
        db.collection("posts").getDocuments { (snapshot, error) in
            // Error
            if error != nil{
                print(error?.localizedDescription)
            }
            
            for i in (snapshot?.documents)!{
                let data = i.data()
                let postCaption = data["caption"] as! String
                let postComments = data["comments"] as! Int
                let postDate = data["date"] as! Date
                let pic = data["imageUrl"] as! String
                let postLikes = data["likes"] as! Int
                let postTags = data["tags"] as! [String]
                let userRef = data["user"] as! String
                let post = Post(caption: postCaption, likes: postLikes, comments: postComments, date: postDate, imageUrl: pic, tags: postTags)
                post.mReference = i.reference
                self.posts += [post]
                self.collectionView?.reloadData()
            }
        }
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        if ((segue.destination as? PostDetailsViewController) != nil){
            let vc = segue.destination as! PostDetailsViewController
            vc.currentPost = selectedPost
        }
        
        if ((segue.destination as? NewPostViewController) != nil){
            let vc = segue.destination as! NewPostViewController
            vc.currentImage = selectedImage
        }
        // Pass the selected object to the new view controller.
    }
 

}
