//
//  FollowersViewController.swift
//  ColemanJustin_FinalProject
//
//  Created by Justin Coleman on 10/28/17.
//  Copyright © 2017 Justin Coleman. All rights reserved.
//

import UIKit
import MaterialComponents
import Firebase

class FollowersViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //MARK: - Outlets
    @IBOutlet weak var usersCollectionView: UICollectionView!
    
    //MARK: - Varibles
    var users = [User]()
    var currentUser: User?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.setToolbarHidden(true, animated: false)
        setupMaterialComponents()
        loadUsers()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Storyboard Actions
    func followTapped(_ sender: MDCRaisedButton){
        sender.removeTarget(self, action: #selector(followTapped(_:)), for: .touchUpInside)
        sender.addTarget(self, action: #selector(unfollowTapped(_:)), for: .touchUpInside)
        sender.setBackgroundColor(UIColor.white, for: .normal)
        sender.setTitle("Following", for: .normal)
        sender.setTitleColor(UIColor.black, for: .normal)
        DatabaseUtil().followUser(users[sender.tag])
    }
    
    func unfollowTapped(_ sender: MDCRaisedButton){
        sender.removeTarget(self, action: #selector(unfollowTapped(_:)), for: .touchUpInside)
        sender.addTarget(self, action: #selector(followTapped(_:)), for: .touchUpInside)
        sender.setBackgroundColor(MDCPalette.blue.tint500, for: .normal)
        sender.setTitle("Follow", for: .normal)
        sender.setTitleColor(UIColor.white, for: .normal)
        DatabaseUtil().unfollowUser(users[sender.tag])
    }
    
    //MARK: - Collection View Callbacks
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "user", for: indexPath) as! UserCell
        let current = users[indexPath.row]
        
        cell.profilePic.pin_updateWithProgress = true
        cell.profilePic.pin_setImage(from: URL(string: current.profilePicUrl))
        cell.usernameLabel.text = current.username.lowercased()
        
        //Shadow
        cell.clipsToBounds = false
        cell.layer.shadowOffset = CGSize(width: 0, height: 0)
        cell.layer.shadowOpacity = 0.2
        cell.layer.shadowRadius = 3
        
        //Corner Radius
        cell.view.layer.masksToBounds = true
        cell.view.layer.cornerRadius = 1.5
        
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
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width - 16, height: 75)
    }
    
    //MARK: - Methods
    func setupMaterialComponents(){
        // AppBar Setup
        let appBar = MDCAppBar()
        title = "Followers"
        self.addChildViewController(appBar.headerViewController)
        appBar.headerViewController.headerView.clipsToBounds = false
        appBar.headerViewController.headerView.layer.shadowOffset = CGSize(width: 0, height: 1)
        appBar.headerViewController.headerView.layer.shadowOpacity = 0.3
        appBar.headerViewController.headerView.layer.shadowRadius = 3
        appBar.headerViewController.headerView.backgroundColor = UIColor.white
        appBar.navigationBar.tintColor = MDCPalette.blueGrey.tint900
        appBar.addSubviewsToParent()
    }
    
    func loadUsers(){
        let db = Firestore.firestore()
        
        if (currentUser?.reference.isEmpty)!{
            print("Error: Reference is Empty")
            return
        }
            db.collection("users").document((currentUser?.reference)!).collection("followers").getDocuments { (snapshot, error) in
            if error != nil{
                print(error?.localizedDescription)
                return
            }
            
            for i in (snapshot?.documents)!{
                let userRef = i.data()["user"] as! String
                
                db.collection("users").document(userRef).getDocument(completion: { (snap, err) in
                    if err != nil{
                        print(err?.localizedDescription)
                        return
                    }
                    let data = snap?.data()
                    let userEmail = data!["email"] as! String
                    let userName = data!["username"] as! String
                    let userBio = data!["bio"] as! String
                    let userHairTypes = data!["hairTypes"] as! [String]
                    let userPic = data!["profilePicUrl"] as! String
                    let userGender = data!["gender"] as! String
                    let userFollowers = data!["followers"] as! Int
                    let userFollowing = data!["following"] as! Int
                    let user = User(email: userEmail, username: userName, bio: userBio, profilePicUrl: userPic, gender: userGender)
                    user.reference = userRef
                    user.hairTypes = userHairTypes
                    user.followerCount = userFollowers
                    user.followingCount = userFollowing
                    self.users.append(user)
                    
                    db.collection("users").document(userRef).collection("followers").whereField("user", isEqualTo: UserDefaultsUtil().loadReference()).getDocuments(completion: { (snaps, er) in
                        if er != nil{
                            print(er?.localizedDescription)
                            return
                        }
                        
                        if snaps?.documents != nil{
                            if (snap?.exists)!{
                            user.iFollow = true
                            }
                        }
                        self.usersCollectionView.reloadData()
                    })
                })
            }
        }
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if let vc = segue.destination as? SelectedProfileViewController{
            vc.selectedUser = currentUser
        }
    }
 

}
