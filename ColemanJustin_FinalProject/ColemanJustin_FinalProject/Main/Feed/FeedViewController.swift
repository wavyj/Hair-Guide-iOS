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
            posts.removeAll()
            loadPosts()
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PostCell
    
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if let cell = cell as? PostCell{
            let selected = posts[indexPath.row]
            if selected.mImage == nil{
                cell.butterDownloadImage(selected)
            } else{
                cell.butterSetImage(selected)
            }
            cell.authorText.text = selected.mUser?.username.lowercased()
            cell.captionText.text = selected.mCaption
            //cell.likeBtn.setImage(UIImage(named: "like")?.withRenderingMode(.alwaysTemplate), for: .normal)
            //cell.likeBtn.tintColor = MDCPalette.grey.tint400
            //cell.commentBtn.setImage(UIImage(named: "comment")?.withRenderingMode(.alwaysTemplate), for: .normal)
            //cell.commentBtn.tintColor = MDCPalette.grey.tint400
            cell.profileImg.layer.cornerRadius = cell.profileImg.frame.size.width / 2
            cell.timeLabel.text = selected.getDate()
            //cell.viewCommentsBtn.setTitle("View All 5 Comments", for: .normal)
            //cell.likesLabel.text = "20 Likes"
            //cell.applyVisuals()
        }
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
    
    func loadPosts(){
        
        // Get Post data
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
                self.loadUser(userRef, post)
                self.posts += [post]
                //self.collectionView?.reloadData()
            }
        }
        
    }
    
    func loadUser(_ ref: String, _ post: Post){
        // Get Post's author data
        let db = Firestore.firestore()
        db.collection("users").document(ref).getDocument { (snapshot, error) in
            if error != nil{
                // Error
                print(error?.localizedDescription)
                return
            }
           
            let data = snapshot?.data()
            let userEmail = data!["email"] as! String
            let userName = data!["username"] as! String
            let userBio = data!["bio"] as! String
            let userHairTypes = data!["hairTypes"] as! [String]
            let userPic = data!["profilePicUrl"] as! String
            let userGender = data!["gender"] as! String
            
            let user = User(email: userEmail, username: userName, bio: userBio, profilePicUrl: userPic, gender: userGender)
            user.hairTypes = userHairTypes
            post.mUser = user
            self.collectionView?.reloadData()
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
        
        if ((segue.destination as? SelectedProfileViewController) != nil){
            let vc = segue.destination as! SelectedProfileViewController
            vc.selectedUser = selectedPost?.mUser
        }
        // Pass the selected object to the new view controller.
    }
 

}
