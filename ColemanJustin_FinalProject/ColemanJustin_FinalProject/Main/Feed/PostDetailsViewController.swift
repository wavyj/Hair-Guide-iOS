//
//  PostDetailsViewController.swift
//  ColemanJustin_FinalProject
//
//  Created by Justin Coleman on 10/13/17.
//  Copyright © 2017 Justin Coleman. All rights reserved.
//

import UIKit
import MaterialComponents
import Firebase

class PostDetailsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //MARK: - Outlets
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var commentsView: UICollectionView!
    @IBOutlet weak var captionText: UITextView!
    @IBOutlet weak var likeBtn: UIImageView!
    @IBOutlet weak var commentBtn: UIImageView!
    @IBOutlet weak var shareBtn: UIImageView!
    @IBOutlet weak var commentInput: MDCTextField!
    @IBOutlet weak var enterBtnContainer: UIView!
    
    //MARK: - Variables
    var currentPost: Post? = nil
    var comments = [Comment]()
    var textController: MDCTextInputController?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        getComments()
        update()
        setupMaterialComponents()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Storyboard Actions
    func backTapped(_ sender: UIBarButtonItem){
        performSegue(withIdentifier: "unwindDetails", sender: self)
    }
    
    func likeTapped(_ sender: UIBarButtonItem){
        
    }
    
    func commentTapped(_ sender: UIBarButtonItem){
        
    }
    
    func shareTapped(_ sender: UIBarButtonItem){
        
    }
    
    func enterTapped(_ sender: MDCFlatButton){
        if !(commentInput?.text?.isEmpty)!{
            let newComment = Comment(text: (commentInput?.text)!, date: Date(), ref: "", user: UserDefaultsUtil().loadReference())
            newComment.mUser = UserDefaultsUtil().loadUserData()
            comments.append(newComment); DatabaseUtil().addComment((currentPost?.mReference?.documentID)!, newComment, commentsView)
            //commentsView.reloadData()
        }
    }
    
    //MARK: - CollectionView Callback
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comments.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "commentCell", for: indexPath) as! CommentCell
        let current = comments[indexPath.row]
        cell.profilePic.pin_setImage(from: URL(string: (current.mUser?.profilePicUrl)!))
        cell.profilePic.pin_updateWithProgress = true
        cell.usernameLabel.text = current.mUser?.username.lowercased()
        cell.commentView.text = current.text
        cell.dateLabel.text = current.dateString
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: commentsView.bounds.width, height: commentsView.bounds.height * 0.3)
    }
    
    //MARK: - Methods
    func setupMaterialComponents(){
        let nib = UINib(nibName: "CommentCell", bundle: nil)
        commentsView?.register(nib, forCellWithReuseIdentifier: "commentCell")
        
        // TextField
        commentInput?.placeholder = "Add a comment..."
        textController = MDCTextInputControllerDefault(textInput: commentInput)
        textController?.activeColor = MDCPalette.blue.tint500
        
        // Button
        let enterBtn = MDCFlatButton()
        enterBtnContainer.addSubview(enterBtn)
        enterBtn.frame = enterBtnContainer.bounds
        enterBtn.setImage(UIImage(named: "share")?.withRenderingMode(.alwaysTemplate), for: .normal)
        enterBtn.tintColor = UIColor.white
        enterBtn.setBackgroundColor(MDCPalette.blue.tint500, for: .normal)
        enterBtn.addTarget(self, action: #selector(enterTapped(_:)), for: .touchUpInside)
        enterBtn.setTitle("", for: .normal)
        
        // AppBar Setup
        let appBar = MDCAppBar()
        self.addChildViewController(appBar.headerViewController)
        appBar.headerViewController.headerView.backgroundColor = MDCPalette.grey.tint100
        appBar.navigationBar.tintColor = MDCPalette.blueGrey.tint900
        //title = "Feed"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back-arrow"), style: .plain, target: self, action: #selector(backTapped(_:)))
        appBar.addSubviewsToParent()
    }
    
    func update(){
        title = (currentPost?.mUser?.username.lowercased())! + "'s Post"
        postImage.pin_setImage(from: URL(string: (currentPost?.mImageUrl)!)!)
        captionText.text = currentPost?.mCaption
        
    }
    
    func getComments(){
        let db = Firestore.firestore()
        db.collection("posts").document((currentPost?.mReference?.documentID)!).collection("comments").order(by: "date", descending: false).getDocuments { (snapshot, error) in
            if error != nil{
                print(error?.localizedDescription)
            }
            
            if snapshot?.documents == nil || (snapshot?.documents.isEmpty)!{
                print("No Comments")
                return
            }
            
            for i in (snapshot?.documents)!{
                let data = i.data()
                let commentText = data["text"] as! String
                let commentDate = data["date"] as! Date
                let commentUser = data["user"] as! String
                let commentRef = i.documentID
                let comment = Comment(text: commentText, date: commentDate, ref: commentRef, user: commentUser)
                self.comments.append(comment)
                self.loadUser(commentUser, comment)
            }
        }
    }
    
    func loadUser(_ userRef: String, _ comment: Comment){
        let db = Firestore.firestore()
        db.collection("users").document(userRef).getDocument { (snapshot, error) in
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
            comment.mUser = user
            DispatchQueue.main.async {
                self.commentsView?.reloadData()
            }
            db.collection("users").document(UserDefaultsUtil().loadReference()).collection("following").whereField("user", isEqualTo: snapshot?.documentID).getDocuments(completion: { (snapshot, err) in
                if err != nil{
                    print(err?.localizedDescription)
                    return
                }
                for i in (snapshot?.documents)!{
                    let ref = i.data()["user"] as! String
                    if ref == user.reference{
                        comment.mUser?.iFollow = true
                    }
                }
            })
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
