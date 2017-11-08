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
import Firebase
import PINRemoteImage

class FeedViewController: UIViewController, FusumaDelegate, UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    //MARK: - Outlets
    @IBOutlet weak var postsCollectionView: UICollectionView!
    @IBOutlet weak var guidesCollectionView: UICollectionView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    //MARK: - Variables
    var posts = [Post]()
    var guides = [Guide]()
    var userGuides = [Guide]()
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
    
    override func viewWillAppear(_ animated: Bool) {
        if self.navigationController != nil{
            if (self.navigationController?.isToolbarHidden)!{
                self.navigationController?.setToolbarHidden(false, animated: false)
            }
        }
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
        loadPosts()
    }
    
    //MARK: - Collection View
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView.tag {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "postCell", for: indexPath) as! PostViewCell
            let selected = posts[indexPath.row]
            cell.imageView.pin_updateWithProgress = true
            cell.imageView.pin_setImage(from: URL(string: selected.mImageUrl)!)
            cell.profileImg.pin_updateWithProgress = true
            cell.profileImg.pin_setImage(from: URL(string: (selected.mUser?.profilePicUrl)!))
            cell.authorText.text = selected.mUser?.username.lowercased()
            cell.captionText.text = selected.mCaption
            cell.timeLabel.text = selected.dateString
            return cell
        case 1:
            return UICollectionViewCell()
        default:
            return UICollectionViewCell()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! PostViewCell
        
        selectedPost = posts[indexPath.row]
        
        performSegue(withIdentifier: "toSelectedPost", sender: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        return CGSize(width: self.view.bounds.width * 0.95, height: (postsCollectionView.bounds.height) * 0.75)
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
        
        let nib = UINib(nibName: "PostViewCell", bundle: nil)
        postsCollectionView?.register(nib, forCellWithReuseIdentifier: "postCell")
        
        appBarHeight = self.view.bounds.height * 0.1
        
        // AppBar Setup
//        let appBar = MDCAppBar()
//        self.addChildViewController(appBar.headerViewController)
//        appBar.headerViewController.headerView.backgroundColor = UIColor.white
//        appBar.navigationBar.tintColor = MDCPalette.blueGrey.tint900
//        title = "Feed"
//        let cameraAction = UIBarButtonItem(image: UIImage(named: "cameraPlus")?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(cameraTapped(_:)))
//        cameraAction.tintColor = UIColor.black
//        navigationItem.rightBarButtonItem = cameraAction
//        appBar.addSubviewsToParent()
    }
    
    func loadPosts(){
        posts.removeAll()
        // Get Post data
        let db = Firestore.firestore()
        db.collection("posts").order(by: "date", descending: true).getDocuments { (snapshot, error) in
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
            let userFollowers = data!["followers"] as! Int
            let userFollowing = data!["following"] as! Int
            let user = User(email: userEmail, username: userName, bio: userBio, profilePicUrl: userPic, gender: userGender)
            user.reference = (snapshot?.documentID)!
            user.hairTypes = userHairTypes
            user.followerCount = userFollowers
            user.followingCount = userFollowing
            post.mUser = user
            DispatchQueue.main.async {
                self.postsCollectionView.reloadData()
            }
            db.collection("users").document(UserDefaultsUtil().loadReference()).collection("following").whereField("user", isEqualTo: snapshot?.documentID).getDocuments(completion: { (snapshot, err) in
                if err != nil{
                    print(err?.localizedDescription)
                    return
                }
                for i in (snapshot?.documents)!{
                    let ref = i.data()["user"] as! String
                    if ref == user.reference{
                        post.mUser?.iFollow = true
                    }
                }
            })
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
