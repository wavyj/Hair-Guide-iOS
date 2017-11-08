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

class ProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //MARK: - Outlets
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var bannerImage: UIImageView!
    @IBOutlet weak var postsLabel: UILabel!
    @IBOutlet weak var guidesLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var followersView: UIView!
    @IBOutlet weak var followingView: UIView!
    @IBOutlet weak var postsView: UIView!
    @IBOutlet weak var guidesView: UIView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var editProfileBtn: MDCRaisedButton!
    @IBOutlet weak var bioText: UITextView!
    @IBOutlet weak var reAnalyzeBtn: MDCRaisedButton!
    @IBOutlet weak var buttonBar: MDCButtonBar!
    @IBOutlet weak var imageBorder: UIView!
    @IBOutlet weak var postsCollectionView: UICollectionView!
    @IBOutlet weak var guidesCollectionView: UICollectionView!
    @IBOutlet weak var signoutBtn: MDCFlatButton!
    
    //MARK: - Variables
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
        
        followersView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showFollowers(_:))))
        followingView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showFollowing(_:))))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if self.navigationController != nil{
            if (self.navigationController?.isToolbarHidden)!{
                self.navigationController?.setToolbarHidden(false, animated: false)
            }
        }
    }
    
    //MARK: - Storyboard Actions
    func settingsTapped(_ sender: UIBarButtonItem){
        let alert = UIAlertController(title: "Signing Out?", message: "Are you sure you want to go? All local data will be removed and you will need to sign in again to continue use.", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: .default) { (action) in
            UserDefaultsUtil().signOut()
            //TODO: Segue to authentication
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "Authentication")
            self.present(vc!, animated: true, completion: nil)
        }
        let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        alert.addAction(yesAction)
        alert.addAction(noAction)
        present(alert, animated: true, completion: nil)
    }
    
    func editTapped(_ sender: MDCRaisedButton){
        performSegue(withIdentifier: "toEditProfile", sender: self)
    }
    
    func guideEditTapped(_ sender: MDCRaisedButton){
        
    }
    
    @IBAction func profileUpdated(_ sender: UIStoryboardSegue){
        update()
    }
    
    func showFollowers(_ sender: UILabel){
        performSegue(withIdentifier: "toFollowers", sender: self)
    }
    
    func showFollowing(_ sender: UILabel){
        performSegue(withIdentifier: "toFollowing", sender: self)
    }
    
    func postsTapped(_ sender: UIBarButtonItem){
        if currentMode != 1{
            currentMode = 1
            updateMode()
        }
    }
    
    func guidesTapped(_ sender: UIBarButtonItem){
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
    
    //MARK: - Methods
    func setupMaterialComponents(){
        let nib = UINib(nibName: "GuideCell", bundle: nil)
        guidesCollectionView?.register(nib, forCellWithReuseIdentifier: "guideCell")
        
        // Buttons
        editProfileBtn.setBackgroundColor(MDCPalette.blue.tint500, for: .normal)
        editProfileBtn.setTitle("Edit Profile", for: .normal)
        editProfileBtn.tintColor = UIColor.white
        editProfileBtn.addTarget(self, action: #selector(editTapped(_:)), for: .touchUpInside)
        reAnalyzeBtn.setBackgroundColor(MDCPalette.blue.tint500, for: .normal)
        reAnalyzeBtn.setTitle(nil, for: .normal)
        reAnalyzeBtn.setImage(UIImage(named: "refresh")?.withRenderingMode(.alwaysTemplate), for: .normal)
        reAnalyzeBtn.tintColor = UIColor.white
        signoutBtn.setImage(UIImage(named: "signout")?.withRenderingMode(.alwaysTemplate), for: .normal)
        signoutBtn.tintColor = UIColor.white
        signoutBtn.addTarget(self, action: #selector(settingsTapped(_:)), for: .touchUpInside)
        let color = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        signoutBtn.setBackgroundColor(color, for: .normal)
        
        // ButtonBar
        buttonBar.backgroundColor = UIColor.white
        let postsAction = UIBarButtonItem(image: UIImage(named: "posts")?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(postsTapped(_:)))
        postsAction.width = view.bounds.width / 3
        postsAction.tintColor = onColor
        let guidesAction = UIBarButtonItem(image: UIImage(named: "guides-light")?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(guidesTapped(_:)))
        guidesAction.width = view.bounds.width / 3
        guidesAction.tintColor = offColor
        let bookmarkAction = UIBarButtonItem(image: UIImage(named: "bookmark"), style: .plain, target: self, action: #selector(bookmarksTapped(_:)))
        bookmarkAction.width = view.bounds.width / 3
        bookmarkAction.tintColor = offColor
        items = [postsAction, guidesAction, bookmarkAction]
        buttonBar.items = items
        
        // Navigation Item
        let settingsAction = UIBarButtonItem(image: UIImage(named: "signout")?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(settingsTapped(_:)))
        settingsAction.tintColor = UIColor.white
        navigationItem.rightBarButtonItem = settingsAction
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
        case 2:
            guidesCollectionView.isHidden = false
            guidesCollectionView.isUserInteractionEnabled = true
            guides.removeAll()
            loadGuides()
            items[1].tintColor = onColor
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
    
    func update(){
        profileImage.pin_updateWithProgress = true
        profileImage.pin_setImage(from: URL(string: (currentUser?.profilePicUrl)!))
        bioText.text = currentUser?.bio
        usernameLabel.text = currentUser?.username.lowercased()
        followersLabel.text = currentUser?.followerCount.description
        followingLabel.text = currentUser?.followingCount.description
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
