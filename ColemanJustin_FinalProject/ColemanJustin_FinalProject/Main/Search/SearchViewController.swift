//
//  SearchViewController.swift
//  ColemanJustin_FinalProject
//
//  Created by Justin Coleman on 10/13/17.
//  Copyright © 2017 Justin Coleman. All rights reserved.
//

import UIKit
import MaterialComponents
import Firebase

class SearchViewController: UIViewController, UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //MARK: - Outlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var usersCollection: UICollectionView!
    @IBOutlet weak var postsCollection: UICollectionView!
    @IBOutlet weak var guidesCollection: UICollectionView!
    
    //MARK: - Variables
    var users = [User]()
    var posts = [Post]()
    var guides = [Guide]()
    var tagsEnabled = false
    var currentMode = 1
    var tagsToSearch = [String.SubSequence]()
    var selectedUser: User?
    var selectedGuide: Guide?
    var selectedPost: Post?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        setupMaterialComponents()
        searchBar.showsCancelButton = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Storyboard Actions
    @objc func tagTapped(_ sender: UIBarButtonItem){
        tagsToSearch.removeAll()
        let alert = UIAlertController(title: "Tags?", message: "Enter any tag(s) seperated by commas", preferredStyle: .alert)
        let enterAction = UIAlertAction(title: "Enter", style: .default) { (_) in
            if let textField = alert.textFields?[0]{
                if !(textField.text?.isEmpty)!{
                    let text = textField.text
                    self.tagsToSearch = (text?.split(separator: ","))!
                    self.queryTags()
                }
            }else{
                
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addTextField { (textField) in
            textField.placeholder = "Example: Straight, Wavy, Curly"
        }
        alert.addAction(enterAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    @objc func followTapped(_ sender: MDCRaisedButton){
        sender.removeTarget(self, action: #selector(followTapped(_:)), for: .touchUpInside)
        sender.addTarget(self, action: #selector(unfollowTapped(_:)), for: .touchUpInside)
        sender.setBackgroundColor(UIColor.white, for: .normal)
        sender.setTitle("Following", for: .normal)
        sender.setTitleColor(UIColor.black, for: .normal)
        DatabaseUtil().followUser(users[sender.tag])
    }
    
    @objc func unfollowTapped(_ sender: MDCRaisedButton){
        sender.removeTarget(self, action: #selector(unfollowTapped(_:)), for: .touchUpInside)
        sender.addTarget(self, action: #selector(followTapped(_:)), for: .touchUpInside)
        sender.setBackgroundColor(MDCPalette.blue.tint500, for: .normal)
        sender.setTitle("Follow", for: .normal)
        sender.setTitleColor(UIColor.white, for: .normal)
        DatabaseUtil().unfollowUser(users[sender.tag])
    }
    
    //MARK: - SearchBar Callbacks
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        switch selectedScope {
        case 0:
            currentMode = 1
            hideCollections()
            usersCollection.isUserInteractionEnabled = true
            usersCollection.isHidden = false
            updateUsers()
            break
        case 1:
            currentMode = 2
            hideCollections()
            postsCollection.isUserInteractionEnabled = true
            postsCollection.isHidden = false
            updatePosts()
            break
        case 2:
            currentMode = 3
            hideCollections()
            guidesCollection.isUserInteractionEnabled = true
            guidesCollection.isHidden = false
            updateGuides()
        default:
            break
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let query = searchBar.text
        if (query?.isEmpty)!{
            return
        }
        self.view.endEditing(true)
        switch currentMode {
        case 1:
            users.removeAll()
            queryUsers(query!)
        case 2:
            posts.removeAll()
            queryPosts(query!)
            break
        case 3:
            guides.removeAll()
            queryGuides(query!)
            break
        default:
            break
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
    
    //MARK: - CollectionView Callbacks
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView.tag {
        case 1:
            return users.count
        case 2:
            return posts.count
        case 3:
            return guides.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView.tag {
        case 1:
            let cell = usersCollection.dequeueReusableCell(withReuseIdentifier: "user", for: indexPath) as! UserCell
            let current = users[indexPath.row]
            if current.profilePicUrl != nil{
                let url = URL(string: current.profilePicUrl)
                if url != nil{
                    cell.profilePic.pin_setImage(from: url)
                }
            }
            
            cell.profilePic.layer.cornerRadius = cell.profilePic.bounds.width / 2
            cell.profilePic.pin_updateWithProgress = true
            cell.usernameLabel.text = current.username.lowercased()
            
            //Shadow
            cell.clipsToBounds = false
            cell.layer.shadowOffset = CGSize(width: 0, height: 0)
            cell.layer.shadowOpacity = 0.2
            cell.layer.shadowRadius = 3
            
            //Corner Radius
            cell.view.layer.masksToBounds = true
            cell.view.layer.cornerRadius = 1.5
            
            if current.reference == UserDefaultsUtil().loadReference(){
                cell.followBtn.isHidden = true
                cell.followBtn.isEnabled = false
            }else{
                if !current.iFollow{
                    cell.followBtn.addTarget(self, action: #selector(followTapped(_:)), for: .touchUpInside)
                    cell.followBtn.setBackgroundColor(MDCPalette.blue.tint500, for: .normal)
                    cell.followBtn.setTitle("Follow", for: .normal)
                    cell.followBtn.setTitleColor(UIColor.white, for: .normal)
                    cell.followBtn.tag = indexPath.row
                }else{
                    cell.followBtn.addTarget(self, action: #selector(unfollowTapped(_:)), for: .touchUpInside)
                    cell.followBtn.setBackgroundColor(UIColor.white, for: .normal)
                    cell.followBtn.setTitle("Following", for: .normal)
                    cell.followBtn.setTitleColor(UIColor.black, for: .normal)
                    cell.followBtn.tag = indexPath.row
                }
            }
            return cell
        case 2:
            let cell = postsCollection.dequeueReusableCell(withReuseIdentifier: "postCell", for: indexPath) as! GridPostCell
            let selected = posts[indexPath.row]
            cell.image.pin_updateWithProgress = true
            cell.image.pin_setImage(from: URL(string: selected.mImageUrl))
            return cell
        case 3:
            let cell = guidesCollection.dequeueReusableCell(withReuseIdentifier: "guideCell", for: indexPath) as! GuideCell
            let current = guides[indexPath.row]
            cell.guideTitle.text = current.mTitle
            cell.viewLabel.text = current.mViews.description
            //cell.image.pin_updateWithProgress = true
            //cell.image.pin_setImage(from: URL(string: current.mImageUrl))
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView.tag{
        case 1:
            return CGSize(width: collectionView.bounds.width - 16, height: 75)
        case 2:
            return CGSize(width: self.view.bounds.width / 3, height: (self.postsCollection?.bounds.height)! / 3 - 60 )
        case 3:
            return CGSize(width: 256, height: 335)
        default:
            return CGSize.init()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView.tag {
        case 1:
            selectedUser = users[indexPath.row]
            performSegue(withIdentifier: "toSelectedUser", sender: self)
        case 2:
            selectedPost = posts[indexPath.row]
            //performSegue(withIdentifier: "toSelectedPost", sender: self)
        case 3:
            selectedGuide = guides[indexPath.row]
            performSegue(withIdentifier: "toSelectedGuide", sender: self)
        default:
            break
        }
    }
    
    //MARK: - Methods
    func setupMaterialComponents(){
        let nib = UINib(nibName: "GuideCell", bundle: nil)
        guidesCollection?.register(nib, forCellWithReuseIdentifier: "guideCell")
        for i in [usersCollection, postsCollection, guidesCollection]{
            i?.allowsMultipleSelection = false
        }
        
        // AppBar Setup
        let appBar = MDCAppBar()
        self.addChildViewController(appBar.headerViewController)
        appBar.headerViewController.headerView.backgroundColor = UIColor.white
        appBar.navigationBar.tintColor = MDCPalette.blueGrey.tint900
        title = "Search"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "tag"), style: .plain, target: self, action: #selector(tagTapped(_:)))
        navigationItem.rightBarButtonItem?.isEnabled = false
        appBar.addSubviewsToParent()
    }
    
    func hideCollections(){
        for i in [usersCollection, postsCollection, guidesCollection]{
            i?.isUserInteractionEnabled = false
            i?.isHidden = true
        }
        
    }
    
    func updateUsers(){
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    func updatePosts(){
        navigationItem.rightBarButtonItem?.isEnabled = true
    }
    
    func updateGuides(){
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    func loadComplete(){
        
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if let vc = segue.destination  as? SelectedProfileViewController{
            vc.selectedUser = selectedUser
        }
        
        if let vc = segue.destination as? SelectedGuideViewController{
            vc.selectedGuide = selectedGuide
        }
        
    }
 

}
extension SearchViewController{
    
    
    func queryUsers(_ query: String){
        let db = Firestore.firestore()
        db.collection("users").getDocuments { (snapsthot, error) in
            if error != nil{
                print(error?.localizedDescription)
                return
            }
            
            for i in (snapsthot?.documents)!{
                
                if i.documentID == UserDefaultsUtil().loadReference(){
                    continue
                }
                let data = i.data()
                let userName = data["username"] as! String
                if !userName.lowercased().contains(query.lowercased()){
                    continue
                }
                let userEmail = data["email"] as! String
                let userBio = data["bio"] as! String
                let userHairTypes = data["hairTypes"] as! [String]
                
                let userPic = data["profilePicUrl"] as! String
                let userGender = data["gender"] as! String
                let userFollowers = data["followers"] as! Int
                let userFollowing = data["following"] as! Int
                let user = User(email: userEmail, username: userName, bio: userBio, profilePicUrl: userPic, gender: userGender)
                user.hairTypes = userHairTypes
                user.followerCount = userFollowers
                user.followingCount = userFollowing
                user.reference = i.documentID
                self.users += [user]
                
                db.collection("users").document(UserDefaultsUtil().loadReference()).collection("following").whereField("user", isEqualTo: user.reference).getDocuments(completion: { (snapshot, err) in
                    if err != nil{
                        print(err?.localizedDescription)
                        return
                    }
                    for i in (snapshot?.documents)!{
                        let ref = i.data()["user"] as! String
                        if ref == user.reference{
                            user.iFollow = true
                        }
                    }
                    self.usersCollection.reloadData()
                })
            }
            print(self.users.count)
            self.loadComplete()
        }
    }
    
    func queryTags(){
        posts.removeAll()
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
                print(postTags)
                var containsTags = false
                for j in self.tagsToSearch{
                    if postTags.contains(String(j)){
                        containsTags = true
                        break
                    }
                }
                if !containsTags{
                    continue
                }
                
                let userRef = data["user"] as! String
                let post = Post(caption: postCaption, likes: postLikes, comments: postComments, date: postDate, imageUrl: pic, tags: postTags)
                post.mReference = i.reference
                self.loadUser(userRef, post)
                self.posts += [post]
                self.postsCollection.reloadData()
            }
            
        }
    }
    
    func queryPosts(_ query: String){
        let db = Firestore.firestore()
        
        db.collection("posts").getDocuments { (snapshot, error) in
            // Error
            if error != nil{
                print(error?.localizedDescription)
            }
            
            for i in (snapshot?.documents)!{
                
                let data = i.data()
                let postCaption = data["caption"] as! String
                print(postCaption)
                if !postCaption.lowercased().contains(query.lowercased()){
                    continue
                }
                
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
                self.postsCollection.reloadData()
            }
            
        }
    }
    
    func loadUser(_ reference: String, _ post: Post){
        let db = Firestore.firestore()
        db.collection("users").document(reference).getDocument { (snapshot, error) in
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
            self.postsCollection.reloadData()
        }
    }
    
    func queryGuides(_ query: String){
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
                if !guideTitle.lowercased().contains(query.lowercased()){
                    continue
                }
                let guideText = i.data()["text"] as! String
                let user = i.data()["user"] as! String
                let view = i.data()["views"] as! Int
                let comment = i.data()["comments"] as! Int
                let guide = Guide(title: guideTitle, text: guideText, viewCount: view, comments: comment, reference: i.reference.documentID)
                guide.mAuthor = user
                self.guides.append(guide)
            }
            self.guidesCollection.reloadData()
        }
    }
}
