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
    @IBOutlet weak var buttonBar: MDCButtonBar!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var selectionBorder: UIView!
    
    //MARK: - Variables
    var posts = [Post]()
    var guides = [Guide]()
    var userGuides = [Guide]()
    var selectedPost: Post? = nil
    var selectedGuide: Guide? = nil
    var appBarHeight: CGFloat? = nil
    var transition: MDCMaskedTransition? = nil
    var selectedImage: UIImage? = nil
    var addedPost: Post? = nil
    var items = [UIBarButtonItem]()
    var currentMode = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationItem.setHidesBackButton(true, animated: false)
        setupMaterialComponents()
        updateMode()
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
    func cameraTapped(){
        if currentMode != 0{
            currentMode = 0
            updateSelectionBorder(currentMode)
            updateMode()
        }
        addedPost = nil
        let fusama = FusumaViewController()
        fusama.delegate = self
        present(fusama, animated: true, completion: nil)
    }
    
    func toNewGuide(){
        if currentMode != 1{
            currentMode = 1
            updateSelectionBorder(currentMode)
            updateMode()
        }
        performSegue(withIdentifier: "toNewGuide", sender: self)
    }
    
    @IBAction func unwind(_ sender: UIStoryboardSegue){
        
    }
    
    @IBAction func newPost(_ sender: UIStoryboardSegue){
        loadPosts()
    }
    
    @IBAction func onNewGuide(_ sender: UIStoryboardSegue){
        if currentMode != 1{
            currentMode = 1
            updateMode()
            updateSelectionBorder(currentMode)
        }
        
        loadGuides()
    }
    
    
    func postsTapped(_ sender: UIBarButtonItem){
        if currentMode != 0{
            currentMode = 0
            updateSelectionBorder(currentMode)
            updateMode()
        }
    }
    
    func guidesTapped(_ sender: UIBarButtonItem){
        if currentMode != 1{
            currentMode = 1
            updateSelectionBorder(currentMode)
            updateMode()
        }
    }
    
    func createTapped(_ sender: UIBarButtonItem){
        performSegue(withIdentifier: "toCreate", sender: self)
    }
    
    func guidesEditTapped(_ sender: UIBarButtonItem){
        
    }
    
    func likePost(_ sender: UITapGestureRecognizer){
        print("Liked")
        let s = sender.view as! UIImageView
        let post = posts[s.tag]
        post.mLikes += 1
        post.iLiked = true
        
        for i in (s.gestureRecognizers)!{
            s.removeGestureRecognizer(i)
        }
        
        // Update Count
        DatabaseUtil().updatePost((post.mReference?.documentID)!, post)
        
        // Update user likes list
        DatabaseUtil().likePost(post)
        
        postsCollectionView.reloadData()
    }
    
    func unLikePost(_ sender: UITapGestureRecognizer){
        print("Unliked")
        let s = sender.view as! UIImageView
        let post = posts[s.tag]
        if post.mLikes > 0{
            post.mLikes -= 1
        }else{
            post.mLikes = 0
        }
        post.iLiked = false
        
        for i in (s.gestureRecognizers)!{
            s.removeGestureRecognizer(i)
        }
        
        // Update Count
        DatabaseUtil().updatePost((post.mReference?.documentID)!, post)
        
        // Update user likes list
        DatabaseUtil().unLikePost(post)
        
        postsCollectionView.reloadData()
    }
    
    func commentTapped(_ sender: UITapGestureRecognizer){
        let s = sender.view as! UIImageView
        selectedPost = posts[s.tag]
        performSegue(withIdentifier: "toSelectedPost", sender: self)
    }
    
    //MARK: - Collection View
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        switch collectionView.tag {
        case 0:
            return 1
        default:
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView.tag {
        case 0:
            return posts.count
        case 1:
            return guides.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView.tag {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "postCell", for: indexPath) as! PostViewCell
            let selected = posts[indexPath.row]
    
            cell.imageView.pin_updateWithProgress = true
            cell.imageView.pin_setImage(from: URL(string: selected.mImageUrl)!)
            cell.profileImg.pin_updateWithProgress = true
            let url = URL(string: (selected.mUser?.profilePicUrl)!)!
            cell.profileImg.pin_setImage(from: url)
            cell.authorText.text = selected.mUser?.username.lowercased()
            cell.captionText.text = selected.mCaption
            cell.timeLabel.text = selected.dateString
            cell.likesLabel.text = selected.mLikes.description
            cell.commentLabel.text = selected.mComments.description
            cell.commentBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(commentTapped(_:))))
            cell.commentBtn.tag = indexPath.row
            
            if selected.iLiked{
                cell.likeBtn.image = UIImage(named: "heart")?.withRenderingMode(.alwaysTemplate)
                cell.likeBtn.tintColor = MDCPalette.red.tint500
                cell.likeBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(unLikePost(_:))))
                cell.likeBtn.tag = indexPath.row
            }else{
                cell.likeBtn.image = UIImage(named: "like")?.withRenderingMode(.alwaysTemplate)
                cell.likeBtn.tintColor = UIColor(white: 0, alpha: 0.5)
                cell.likeBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(likePost(_:))))
                cell.likeBtn.tag = indexPath.row
            }
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "guideCell", for: indexPath) as! GuideCell
            let current = guides[indexPath.row]
            cell.guideTitle.text = current.mTitle
            cell.viewLabel.text = current.mViews.description
            if current.mAuthor == UserDefaultsUtil().loadReference(){
                cell.editBtn.tag = indexPath.row
                cell.editBtn.addTarget(self, action: #selector(guidesEditTapped(_:)), for: .touchUpInside)
                cell.editBtn.isEnabled = true
                cell.editBtn.isHidden = false
            }else{
                cell.editBtn.isHidden = true
                cell.editBtn.isEnabled = false
            }
            return cell
        default:
            return UICollectionViewCell()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView.tag {
        case 0: break
            
        case 1:
            selectedGuide = guides[indexPath.item]
            performSegue(withIdentifier: "toSelectedGuide", sender: self)
        default:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        switch collectionView.tag {
        case 0:
            return CGSize(width: collectionView.bounds.width * 0.9, height: collectionView.bounds.height * 0.75)
        case 1:
            return CGSize(width: 256, height: 335)
        default:
            return CGSize()
        }
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
        
        let guideNib = UINib(nibName: "GuideCell", bundle: nil)
        guidesCollectionView?.register(guideNib, forCellWithReuseIdentifier: "guideCell")
        
        appBarHeight = self.view.bounds.height * 0.1
        
        selectionBorder.backgroundColor = MDCPalette.blue.tint500
        
        //Button Bar
        let postsAction = UIBarButtonItem(title: "Posts", style: .plain, target: self, action: #selector(postsTapped(_:)))
        postsAction.width = view.bounds.width / 3
       
        let guidesAction = UIBarButtonItem(title: "Guides", style: .plain, target: self, action: #selector(guidesTapped(_:)))
        guidesAction.width = view.bounds.width / 3
        
        let addAction = UIBarButtonItem(image: UIImage(named: "create")?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(createTapped(_:)))
        addAction.width = view.bounds.width / 3
        addAction.title = ""
        addAction.tintColor = UIColor(white: 0, alpha: 0.4)
    
        items = [postsAction, guidesAction, addAction]
        buttonBar.items = items
        buttonBar.tintColor = UIColor.black
        
        // Shadow
        buttonBar.clipsToBounds = false
        buttonBar.layer.shadowOffset = CGSize(width: 0, height: 1)
        buttonBar.layer.shadowOpacity = 0.3
        buttonBar.layer.shadowRadius = 3
        
    }
    
    func updateMode(){
        for i in [postsCollectionView, guidesCollectionView]{
            i?.isHidden = true
            i?.isUserInteractionEnabled = false
        }
        spinner.startAnimating()
        switch currentMode {
        case 0:
            postsCollectionView.isHidden = false
            postsCollectionView.isUserInteractionEnabled = true
            posts.removeAll()
            loadPosts()
            
        case 1:
            guidesCollectionView.isHidden = false
            guidesCollectionView.isUserInteractionEnabled = true
            guides.removeAll()
            loadGuides()
            
        default:
            break
        }
        //buttonBar.items?.removeAll()
        //buttonBar.items = items
    }
    
    func updateSelectionBorder(_ mode: Int){
        if mode == 0{
            UIView.animate(withDuration: 0.4, animations: {
                //self.borderTrailing.isActive = false
                //self.borderLeading.isActive = true
                
                self.selectionBorder.frame = CGRect(x: 0.0, y: self.buttonBar.bounds.height - (self.buttonBar.bounds.height * 0.1), width: self.view.bounds.width / 3, height: self.buttonBar.bounds.height * 0.1)
            })
        }else{
            UIView.animate(withDuration: 0.4, animations: {
                //self.borderLeading.isActive = false
                //self.borderTrailing.isActive = true
            
                self.selectionBorder.frame = CGRect(x: self.view.bounds.width / 3, y: self.buttonBar.bounds.height - (self.buttonBar.bounds.height * 0.1), width: self.view.bounds.width / 3, height: self.buttonBar.bounds.height * 0.1)
            })
        }
        
        
    }
    
    func loadPosts(){
        posts.removeAll()
        // Get Post data
        let db = Firestore.firestore()
        db.collection("posts").order(by: "date", descending: true).getDocuments { (snapshot, error) in
            // Error
            if error != nil{
                print(error?.localizedDescription)
        
                DispatchQueue.main.async {
                    self.spinner.stopAnimating()
                }
                return
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
                self.checkLiked(post, userRef)
                self.countComments(post)
                self.posts += [post]
            }
            
        }
        
    }
    
    func countComments(_ post: Post){
        let db = Firestore.firestore()
        db.collection("posts").document((post.mReference?.documentID)!).collection("comments").getDocuments { (snapshot, error) in
            if error != nil{
                print(error?.localizedDescription)
                return
            }
            
            if snapshot?.documents == nil{
                return
            }
            
            post.mComments = (snapshot?.documents.count)!
        }
    }
    
    func checkLiked(_ post: Post, _ user: String){
        let db = Firestore.firestore()
        db.collection("users").document(UserDefaultsUtil().loadReference()).collection("likes").whereField("post", isEqualTo: post.mReference?.documentID).getDocuments { (snapshot, error) in
            if error != nil{
                print(error?.localizedDescription)
                return
            }
            
            if snapshot?.documents == nil{
                return
            }
            
            if (snapshot?.documents.count)! > 0{
                post.iLiked = true
            }
            
            self.loadUser(user, post)
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
            
            DispatchQueue.main.async {
                self.spinner.stopAnimating()
            }
        }
    }
    
    func loadGuides(){
        let db = Firestore.firestore()
        db.collection("guides").getDocuments { (snapshot, error) in
            if error != nil{
                // Error
                print(error?.localizedDescription)
                
                DispatchQueue.main.async {
                    self.spinner.stopAnimating()
                }
                return
            }
            
            // Get Each Guide data
            self.guides.removeAll()
            
            for i in (snapshot?.documents)!{
                let guideTitle = i.data()["title"] as! String
                let guideText = i.data()["text"] as! String
                let user = i.data()["user"] as! String
                let view = i.data()["views"] as! Int
                let comment = i.data()["comments"] as! Int
                let guide = Guide(title: guideTitle, text: guideText, viewCount: view, comments: comment, reference: i.reference.documentID)
                guide.mAuthor = user
                self.guides.append(guide)
            }
            self.guidesCollectionView.reloadData()
            
            DispatchQueue.main.async {
                self.spinner.stopAnimating()
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
        
        if ((segue.destination as? SelectedProfileViewController) != nil){
            let vc = segue.destination as! SelectedProfileViewController
            vc.selectedUser = selectedPost?.mUser
        }
        
        if let vc = segue.destination as? SelectedGuideViewController{
            vc.selectedGuide = selectedGuide
        }
        
        if let vc = segue.destination as? CreateViewController{
            vc.parentVC = self
        }
        
        // Pass the selected object to the new view controller.
    }
 

}
