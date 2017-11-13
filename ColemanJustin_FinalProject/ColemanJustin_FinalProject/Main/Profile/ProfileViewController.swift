//
//  ProfileViewController.swift
//  ColemanJustin_FinalProject
//
//  Created by Justin Coleman on 10/13/17.
//  Copyright © 2017 Justin Coleman. All rights reserved.
//

import UIKit
import MaterialComponents
import Firebase

class ProfileViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var postsLabel: UILabel!
    @IBOutlet weak var guidesLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var followersView: UIView!
    @IBOutlet weak var followingView: UIView!
    @IBOutlet weak var postsView: UIView!
    @IBOutlet weak var guidesView: UIView!
    @IBOutlet weak var bioText: UITextView!
    @IBOutlet weak var buttonBar: MDCButtonBar!
    @IBOutlet weak var imageBorder: UIView!
    @IBOutlet weak var postsCollectionView: UICollectionView!
    @IBOutlet weak var guidesCollectionView: UICollectionView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    //MARK: - Variables
    var headerVC: MDCFlexibleHeaderViewController? = nil
    var currentUser: User? = nil
    var posts = [Post]()
    var guides = [Guide]()
    var currentMode = 1
    var items = [UIBarButtonItem]()
    let onColor = MDCPalette.blue.tint500
    let offColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.2)

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationItem.setHidesBackButton(true, animated: false)
        setupMaterialComponents()
        
        profileImage.layer.cornerRadius = 2
        currentUser = UserDefaultsUtil().loadUserData()
        update()
        loadProfile()
        updateMode()
        loadGuides()
        
        followersView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showFollowers(_:))))
        followingView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showFollowing(_:))))
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
    @objc func settingsTapped(_ sender: UIBarButtonItem){
        performSegue(withIdentifier: "toSettings", sender: self)
    }
    
    func editTapped(_ sender: MDCRaisedButton){
        performSegue(withIdentifier: "toEditProfile", sender: self)
    }
    
    @objc func guideEditTapped(_ sender: MDCRaisedButton){
        
    }
    
    @IBAction func profileUpdated(_ sender: UIStoryboardSegue){
        update()
    }
    
    @objc func showFollowers(_ sender: UILabel){
        performSegue(withIdentifier: "toFollowers", sender: self)
    }
    
    @objc func showFollowing(_ sender: UILabel){
        performSegue(withIdentifier: "toFollowing", sender: self)
    }
    
    @objc func postsTapped(_ sender: UIBarButtonItem){
        if currentMode != 1{
            currentMode = 1
            updateMode()
        }
    }
    
    @objc func guidesTapped(_ sender: UIBarButtonItem){
        if currentMode != 2{
            currentMode = 2
            updateMode()
        }
    }
    
    func bookmarksTapped(_ sender: UIBarButtonItem){
        if currentMode != 3{
            currentMode = 3
            updateMode()
        }
    }


    //MARK: - Methods
    func setupMaterialComponents(){
        let nib = UINib(nibName: "GuideCell", bundle: nil)
        guidesCollectionView?.register(nib, forCellWithReuseIdentifier: "guideCell")
        
        // ButtonBar
        buttonBar.backgroundColor = UIColor.white
        buttonBar.clipsToBounds = false
        buttonBar.layer.shadowOffset = CGSize(width: 0, height: 0)
        buttonBar.layer.shadowOpacity = 0.3
        buttonBar.layer.shadowRadius = 3
        let postsAction = UIBarButtonItem(image: UIImage(named: "posts")?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(postsTapped(_:)))
        postsAction.width = view.bounds.width / 2
        postsAction.tintColor = onColor
        let guidesAction = UIBarButtonItem(image: UIImage(named: "guides-light")?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(guidesTapped(_:)))
        guidesAction.width = view.bounds.width / 2
        guidesAction.tintColor = offColor
        
        items = [postsAction, guidesAction]
        buttonBar.items = items
        
        
        // AppBar Setup
        let appBar = MDCAppBar()
        self.addChildViewController(appBar.headerViewController)
        appBar.headerViewController.headerView.trackingScrollView = scrollView
        scrollView.delegate = appBar.headerViewController
        appBar.headerViewController.headerView.backgroundColor = UIColor.white
        headerVC = appBar.headerViewController
        headerVC?.headerView.shiftBehavior = .enabledWithStatusBar
        appBar.navigationBar.tintColor = MDCPalette.blueGrey.tint900
        let settingsOption = UIBarButtonItem(image: UIImage(named: "more"), style: .plain, target: self, action: #selector(settingsTapped(_:)))
        navigationItem.rightBarButtonItem = settingsOption
        title = currentUser?.username.lowercased()
        appBar.addSubviewsToParent()
    }
    
    func updateMode(){
        for i in [postsCollectionView, guidesCollectionView]{
            i?.isHidden = true
            i?.isUserInteractionEnabled = false
        }
        for i in items{
            i.image = i.image?.withRenderingMode(.alwaysTemplate)
            i.tintColor = offColor
        }
        
        switch currentMode {
        case 1:
            postsCollectionView.isHidden = false
            postsCollectionView.isUserInteractionEnabled = true
            posts.removeAll()
            loadPosts()
            items[0].tintColor = onColor
            postsView.alpha = 1
            guidesView.alpha = 0.4
        case 2:
            guidesCollectionView.isHidden = false
            guidesCollectionView.isUserInteractionEnabled = true
            guides.removeAll()
            loadGuides()
            items[1].tintColor = onColor
            postsView.alpha = 0.4
            guidesView.alpha = 1
        case 3:
            guidesCollectionView.isHidden = false
            guidesCollectionView.isUserInteractionEnabled = true
            guides.removeAll()
            loadBookmarks()
            items[2].tintColor = onColor
        default:
            break
        }
        buttonBar.items?.removeAll()
        buttonBar.items = items
    }
    
    
    
    func update(){
        profileImage.pin_updateWithProgress = true
        profileImage.pin_setImage(from: URL(string: (currentUser?.profilePicUrl)!))
        profileImage.layer.cornerRadius = profileImage.bounds.width / 2
        bioText.text = currentUser?.bio
        followersLabel.text = currentUser?.followerCount.description
        followingLabel.text = currentUser?.followingCount.description
        title = currentUser?.username
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if let vc = segue.destination as? EditProfileViewController{
            vc.currentUser = currentUser
        }
        
        if let vc = segue.destination as? FollowersViewController{
            vc.currentUser = currentUser
        }
        
        if let vc = segue.destination as? FollowingViewController{
            vc.currentUser = currentUser
        }
    }
 

}

extension ProfileViewController{
    //MARK: - Load Methods
    func loadProfile(){
        let db = Firestore.firestore()
        db.collection("users").document(UserDefaultsUtil().loadReference()).getDocument { (snapshot, error) in
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
            user.hairTypes = userHairTypes
            user.followerCount = userFollowers
            user.followingCount = userFollowing
            user.reference = (snapshot?.documentID)!
            self.currentUser = user
            self.update()
            UserDefaultsUtil().saveUserData(user)
        }
    }
    
    func loadPosts(){
        posts.removeAll()
        
        // Get Post data
        let db = Firestore.firestore()
        db.collection("posts").whereField("user", isEqualTo: UserDefaultsUtil().loadReference()).getDocuments { (snapshot, error) in
            if error != nil{
                print(error?.localizedDescription)
                return
            }
            
            DispatchQueue.main.async {
                self.postsLabel.text = (snapshot?.documents.count)!.description
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
                self.loadUser(userRef, post)
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
            user.hairTypes = userHairTypes
            user.followerCount = userFollowers
            user.followingCount = userFollowing
            post.mUser = user
            self.postsCollectionView.reloadData()
        }
    }
    
    func loadGuides(){
        let db = Firestore.firestore()
        db.collection("guides").getDocuments { (snapshot, error) in
            if error != nil{
                // Error
                print(error?.localizedDescription)
                return
            }
            
            // Get Each Guide data
            self.guides.removeAll()
            
            DispatchQueue.main.async {
                self.guidesLabel.text = (snapshot?.documents.count)!.description
            }
            
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
        }
    }
    
    func loadBookmarks(){
        let db = Firestore.firestore()
        db.collection("users").document(UserDefaultsUtil().loadReference()).collection("bookmarks").getDocuments { (snapshot, error) in
            if error != nil{
                print(error?.localizedDescription)
                return
            }
            
            for i in (snapshot?.documents)!{
                let guideRef = i.data()["guide"] as! String
                
                db.collection("guides").document(guideRef).getDocument(completion: { (snapshot, error) in
                    if error != nil{
                        print(error?.localizedDescription)
                        return
                    }
                    
                    let data = snapshot?.data()
                    let guideTitle = data!["title"] as! String
                    let guideText = data!["text"] as! String
                    let user = data!["user"] as! String
                    let view = data!["views"] as! Int
                    let comment = data!["comments"] as! Int
                    let guide = Guide(title: guideTitle, text: guideText, viewCount: view, comments: comment, reference: guideRef)
                    guide.mAuthor = user
                    self.guides.append(guide)
                    self.guidesCollectionView.reloadData()
                })
            }
            
        }
    }
}

extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    //MARK: - CollectionView Callbacks
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView.tag {
        case 1:
            return posts.count
        case 2:
            return guides.count
        default:
            return guides.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView.tag {
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "postCell", for: indexPath) as! GridPostCell
            let selected = posts[indexPath.row]
            cell.image.pin_updateWithProgress = true
            cell.image.pin_setImage(from: URL(string: selected.mImageUrl))
            return cell
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "guideCell", for: indexPath) as! GuideCell
            let current = guides[indexPath.row]
            cell.guideTitle.text = current.mTitle
            cell.viewLabel.text = current.mViews.description
            if current.mAuthor == UserDefaultsUtil().loadReference(){
                cell.editBtn.tag = indexPath.row
                cell.editBtn.addTarget(self, action: #selector(guideEditTapped(_:)), for: .touchUpInside)
                cell.editBtn.isEnabled = true
                cell.editBtn.isHidden = false
            }else{
                cell.editBtn.isHidden = true
                cell.editBtn.isEnabled = false
            }
            return cell
        default:
            break
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "", for: indexPath)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView.tag {
        case 1:
            return CGSize(width: self.view.bounds.width / 3, height: (self.postsCollectionView?.bounds.height)! / 3)
        case 2:
            return CGSize(width: 256, height: 335)
        default:
            return CGSize()
        }
    }
}

extension ProfileViewController: UIScrollViewDelegate{
    //MARK: - Scrollview Callbacks
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        headerVC?.headerView.trackingScrollDidScroll()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        headerVC?.headerView.trackingScrollDidEndDecelerating()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        headerVC?.headerView.trackingScrollDidEndDraggingWillDecelerate(decelerate)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        headerVC?.headerView.trackingScrollWillEndDragging(withVelocity: velocity, targetContentOffset: targetContentOffset)
    }
}

