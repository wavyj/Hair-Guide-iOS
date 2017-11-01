//
//  SelectedProfileViewController.swift
//  ColemanJustin_FinalProject
//
//  Created by Justin Coleman on 10/18/17.
//  Copyright © 2017 Justin Coleman. All rights reserved.
//

import UIKit
import MaterialComponents
import ImageButter
import Firebase

class SelectedProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //MARK: - Outlets
    @IBOutlet weak var profileImage: WebPImageView!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var followBtn: MDCRaisedButton!
    @IBOutlet weak var bioView: UIView!
    @IBOutlet weak var bioText: UITextView!
    @IBOutlet weak var buttonBar: MDCButtonBar!
    @IBOutlet weak var imageContainer: UIView!
    @IBOutlet weak var postsCollectionView: UICollectionView!
    @IBOutlet weak var guidesCollectionView: UICollectionView!
    
    //MARK: - Variables
    var selectedUser: User? = nil
    var posts = [Post]()
    var guides = [Guide]()
    var currentMode = 1
    var items = [UIBarButtonItem]()
    let onColor = MDCPalette.blue.tint500
    let offColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.2)

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        imageContainer.layer.cornerRadius = imageContainer.frame.width / 2
        setupMaterialComponents()
        update()
        updateMode()
        followersLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showFollowers(_:))))
        followingLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showFollowing(_:))))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Storyboard Methods
    func followTapped(_ sender: MDCRaisedButton){
        sender.removeTarget(self, action: #selector(followTapped(_:)), for: .touchUpInside)
        sender.addTarget(self, action: #selector(unfollowTapped(_:)), for: .touchUpInside)
        sender.setBackgroundColor(UIColor.white, for: .normal)
        sender.setTitle("Following", for: .normal)
        sender.setTitleColor(UIColor.black, for: .normal)
        //DatabaseUtil().followUser(selectedUser!)
    }
    
    func unfollowTapped(_ sender: MDCRaisedButton){
        sender.removeTarget(self, action: #selector(unfollowTapped(_:)), for: .touchUpInside)
        sender.addTarget(self, action: #selector(followTapped(_:)), for: .touchUpInside)
        sender.setBackgroundColor(MDCPalette.blue.tint500, for: .normal)
        sender.setTitle("Follow", for: .normal)
        sender.setTitleColor(UIColor.white, for: .normal)
        //DatabaseUtil().unfollowUser(selectedUser!)
    }
    
    func postsTapped(_ sender: UIBarButtonItem){
        currentMode = 1
        updateMode()
    }
    
    func guidesTapped(_ sender: UIBarButtonItem){
        currentMode = 2
        updateMode()
    }
    
    func guidesEditTapped(_ sender: MDCRaisedButton){
        
    }
    
    func showFollowers(_ sender: UILabel){
        performSegue(withIdentifier: "toFollowers", sender: self)
    }
    
    func showFollowing(_ sender: UILabel){
        //performSegue(withIdentifier: "toFollowing", sender: self)
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
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView.tag {
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "postCell", for: indexPath) as! GridPostCell
            let selected = posts[indexPath.row]
            cell.image.url = URL(string: selected.mImageUrl)
            return cell
        case 2:
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
        
        // ButtonBar
        buttonBar.backgroundColor = MDCPalette.grey.tint50
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
        appBar.headerViewController.headerView.backgroundColor = MDCPalette.grey.tint100
        appBar.navigationBar.tintColor = MDCPalette.blueGrey.tint900
        title = selectedUser?.username.lowercased()
        appBar.addSubviewsToParent()
    }
    
    func update(){
        profileImage.url = URL(string: (selectedUser?.profilePicUrl)!)
        followersLabel.text = selectedUser?.followerCount.description
        followingLabel.text = selectedUser?.followingCount.description
        
        if !(selectedUser?.iFollow)!{
            followBtn.addTarget(self, action: #selector(followTapped(_:)), for: .touchUpInside)
            followBtn.setBackgroundColor(MDCPalette.blue.tint500, for: .normal)
            followBtn.setTitle("Follow", for: .normal)
            followBtn.setTitleColor(UIColor.white, for: .normal)
        }else{
            followBtn.addTarget(self, action: #selector(unfollowTapped(_:)), for: .touchUpInside)
            followBtn.setBackgroundColor(UIColor.white, for: .normal)
            followBtn.setTitle("Following", for: .normal)
            followBtn.setTitleColor(UIColor.black, for: .normal)
        }
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
        default:
            break
        }
        buttonBar.items?.removeAll()
        buttonBar.items = items
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if let vc = segue.destination as? FollowersViewController{
            vc.currentUser = selectedUser
        }
        
        if let vc = segue.destination as? FollowingViewController{
            vc.currentUser = selectedUser
        }
    }
 

}
