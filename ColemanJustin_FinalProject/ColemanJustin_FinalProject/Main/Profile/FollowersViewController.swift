//
//  FollowersViewController.swift
//  ColemanJustin_FinalProject
//
//  Created by Justin Coleman on 10/28/17.
//  Copyright © 2017 Justin Coleman. All rights reserved.
//

import UIKit
import MaterialComponents
import ImageButter
import Firebase

class FollowersViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //MARK: - Outlets
    @IBOutlet weak var usersCollectionView: UICollectionView!
    
    //MARK: - Varibles
    var users = [User]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Storyboard Actions
    func followTapped(_ sender: MDCRaisedButton){
        
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
        appBar.headerViewController.headerView.backgroundColor = MDCPalette.grey.tint100
        appBar.navigationBar.tintColor = MDCPalette.blueGrey.tint900
        appBar.addSubviewsToParent()
    }
    
    func loadUsers(){
        let db = Firestore.firestore()
        db.collection("users").document(UserDefaultsUtil().loadReference()).collection("followers").getDocuments { (snapshot, error) in
            if error != nil{
                print(error?.localizedDescription)
                return
            }
            
            for i in (snapshot?.documents)!{
                let userRef = i.data()["user"] as! String
                
                db.collection("users").document(userRef).getDocument(completion: { (snapshot, err) in
                    if err != nil{
                        print(err?.localizedDescription)
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
                    user.reference = userRef
                    user.hairTypes = userHairTypes
                    user.followerCount = userFollowers
                    user.followingCount = userFollowing
                    self.users.append(user)
                    self.usersCollectionView.reloadData()
                })
            }
        }
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
