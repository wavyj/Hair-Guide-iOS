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
import ImageButter

class ProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //MARK: - Outlets
    @IBOutlet weak var profileImage: WebPImageView!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var editProfileBtn: MDCRaisedButton!
    @IBOutlet weak var bioView: UIView!
    @IBOutlet weak var bioText: UITextView!
    @IBOutlet weak var reAnalyzeBtn: MDCRaisedButton!
    @IBOutlet weak var pagerBar: UIView!
    @IBOutlet weak var imageContainer: UIView!
    @IBOutlet weak var postsCollectionView: UICollectionView!
    
    //MARK: - Variables
    var currentUser: User? = nil
    var posts = [Post]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationItem.setHidesBackButton(true, animated: false)
        setupMaterialComponents()
        
        imageContainer.layer.cornerRadius = imageContainer.frame.size.width / 2
        currentUser = UserDefaultsUtil().loadUserData()
        update()
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
    
    @IBAction func profileUpdated(_ sender: UIStoryboardSegue){
        update()
    }
    
    //MARK: - CollectionView Callbacks
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "postCell", for: indexPath) as! GridPostCell
        //cell.image.image = WebPImage(image: UIImage(named: "image1"))
        //cell.image.frame = cell.bounds
        //let current = posts.first
        //cell.image.url = URL(string: (current?.mImageUrl)!)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width = collectionView.bounds.width / 3
        var height = collectionView.bounds.height * 0.5
        return CGSize(width: width, height: height)
    }
    
    //MARK: - Methods
    func setupMaterialComponents(){
        
        // Buttons
        editProfileBtn.setTitle("Edit Profile", for: .normal)
        editProfileBtn.tintColor = MDCPalette.blue.tint500
        editProfileBtn.addTarget(self, action: #selector(editTapped(_:)), for: .touchUpInside)
        reAnalyzeBtn.setImage(UIImage(named: "refresh")?.withRenderingMode(.alwaysTemplate), for: .normal)
        reAnalyzeBtn.tintColor = MDCPalette.blue.tint500
        
        
        // ButtonBar
        //buttonBar.backgroundColor = MDCPalette.grey.tint100
        
        // AppBar Setup
        let appBar = MDCAppBar()
        self.addChildViewController(appBar.headerViewController)
        appBar.headerViewController.headerView.backgroundColor = MDCPalette.grey.tint100
        appBar.navigationBar.tintColor = MDCPalette.blueGrey.tint900
        let settingsAction = UIBarButtonItem(image: UIImage(named: "signout")?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(settingsTapped(_:)))
        settingsAction.tintColor = UIColor.black
        navigationItem.rightBarButtonItem = settingsAction
        appBar.addSubviewsToParent()
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
            print(snapshot?.documents.count)
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
            }
            self.postsCollectionView.reloadData()
        }
        
    }
    
    func update(){
        profileImage.url = URL(string: currentUser!.profilePicUrl)
        let loadingView = WebPLoadingView()
        loadingView.lineColor = MDCPalette.blue.tint500
        loadingView.lineWidth = 2
        profileImage.loadingView = loadingView
        bioText.text = currentUser?.bio
        title = currentUser?.username.lowercased()
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if let vc = segue.destination as? EditProfileViewController{
            vc.currentUser = currentUser
        }
    }
 

}
