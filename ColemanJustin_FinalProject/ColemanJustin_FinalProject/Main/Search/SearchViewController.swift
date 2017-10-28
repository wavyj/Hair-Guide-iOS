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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        setupMaterialComponents()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Storyboard Actions
    func tagTapped(_ sender: UIBarButtonItem){
        
    }
    
    func followTapped(_ sender: UIBarButtonItem){
        
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
        switch currentMode {
        case 1:
            queryUsers(query!)
        case 2:
            break
        case 3:
            break
        default:
            break
        }
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
            cell.profilePic.url = URL(string: (current.profilePicUrl))
            cell.profilePic.frame = cell.profilePicContainer.bounds
            cell.usernameLabel.text = current.username.lowercased()
            cell.profilePicContainer.layer.cornerRadius = cell.profilePicContainer.bounds.width / 2
            if current.reference == UserDefaultsUtil().loadReference(){
                cell.followBtn.isHidden = true
                cell.followBtn.isEnabled = false
            }else{
                cell.followBtn.addTarget(self, action: #selector(followTapped(_:)), for: .touchUpInside)
                cell.followBtn.setBackgroundColor(MDCPalette.blue.tint500, for: .normal)
                cell.followBtn.setTitle("Follow", for: .normal)
                cell.followBtn.setTitleColor(UIColor.white, for: .normal)
            }
            return cell
        case 2:
            let cell = postsCollection.dequeueReusableCell(withReuseIdentifier: "post", for: indexPath) as! PostCell
            
            return cell
        case 3:
            let cell = guidesCollection.dequeueReusableCell(withReuseIdentifier: "guide", for: indexPath) as! GuideCell
            
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width - 16, height: 75)
    }
    
    //MARK: - Methods
    func setupMaterialComponents(){
        
        // AppBar Setup
        let appBar = MDCAppBar()
        self.addChildViewController(appBar.headerViewController)
        appBar.headerViewController.headerView.backgroundColor = MDCPalette.grey.tint100
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

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
                let userFollowersList = data["followerList"] as! [String]
                let userFollowingsList = data["followingList"] as! [String]
                let user = User(email: userEmail, username: userName, bio: userBio, profilePicUrl: userPic, gender: userGender)
                user.hairTypes = userHairTypes
                user.followerCount = userFollowers
                user.followingCount = userFollowing
                user.followerList = userFollowersList
                user.followingList = userFollowingsList
                user.reference = i.documentID
                self.users += [user]
                self.usersCollection.reloadData()
            }
        }
        self.loadComplete()
    }
}
