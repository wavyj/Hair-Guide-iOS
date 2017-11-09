//
//  Firestore.swift
//  ColemanJustin_FinalProject
//
//  Created by Justin Coleman on 10/17/17.
//  Copyright © 2017 Justin Coleman. All rights reserved.
//

import Foundation
import Firebase

class DatabaseUtil{
    var ref: DocumentReference? = nil
    var db: Firestore? = nil
    
    init(){
        db = Firestore.firestore()
    }
    
    func createUser(_ newUser: User){
        if UserDefaultsUtil().checkFB(){
            let fb = UserDefaultsUtil().loadFBData()
            ref = db?.collection("users").addDocument(data: ["email" : newUser.email,
                                                             "username": newUser.username,
                                                             "profilePicUrl": "",
                                                             "bio": "",
                                                             "gender": "", "hairTypes": [], "followers": 0, "following": 0, "fbuser": fb.first], completion: { (error) in
                                                                if let error = error{
                                                                    print("Error adding document: \(error)")
                                                                } else{
                                                                    UserDefaultsUtil().saveReference(DocumentID: (self.ref?.documentID)!)
                                                                    print("Document added with ID: \(self.ref!.documentID)")
                                                                }
            })
        }else{
        ref = db?.collection("users").addDocument(data: ["email" : newUser.email,
         "username": newUser.username,
         "profilePicUrl": "",
         "bio": "",
         "gender": "", "hairTypes": [], "followers": 0, "following": 0], completion: { (error) in
            if let error = error{
                print("Error adding document: \(error)")
            } else{
                UserDefaultsUtil().saveReference(DocumentID: (self.ref?.documentID)!)
                print("Document added with ID: \(self.ref!.documentID)")
            }
        })
        }
    }
    
    func getUser(_ email: String){
        db?.collection("users").whereField("email", isEqualTo: email).getDocuments(completion: { (snapshot, error) in
            if error != nil{
                // Error
                print(error?.localizedDescription)
            }
        
            UserDefaultsUtil().saveReference(DocumentID: (snapshot?.documents[0].reference.documentID)!)
            let userData = snapshot?.documents[0].data()
            let username = userData!["username"] as! String
            let email = userData!["email"] as! String
            let pic = userData!["profilePicUrl"] as! String
            let gender = userData!["gender"] as! String
            let bio = userData!["bio"] as! String
            let followers = userData!["followers"] as! Int
            let following = userData!["following"] as! Int
            let user = User(email: email, username: username, bio: bio, profilePicUrl: pic, gender: gender)
            user.followerCount = followers
            user.followingCount = following
            if let fb = userData!["fbuser"] as? String{
                user.fb = fb
            }
            UserDefaultsUtil().saveUserData(user)
        })
        
    }
    
    func getFbUser(_ token: String){
        db?.collection("users").whereField("fbuser", isEqualTo: token).getDocuments(completion: { (snapshot, error) in
            if error != nil{
                // Error
                print(error?.localizedDescription)
            }
            
            UserDefaultsUtil().saveReference(DocumentID: (snapshot?.documents[0].reference.documentID)!)
            let userData = snapshot?.documents[0].data()
            let username = userData!["username"] as! String
            let email = userData!["email"] as! String
            let pic = userData!["profilePicUrl"] as! String
            let gender = userData!["gender"] as! String
            let bio = userData!["bio"] as! String
            let followers = userData!["followers"] as! Int
            let following = userData!["following"] as! Int
            let user = User(email: email, username: username, bio: bio, profilePicUrl: pic, gender: gender)
            user.followerCount = followers
            user.followingCount = following
            if let fb = userData!["fbuser"] as? String{
                user.fb = fb
            }
            UserDefaultsUtil().saveUserData(user)
        })
    }
    
    func updateUser(_ user: User){
        if user.fb != nil{
            db?.collection("users").document(UserDefaultsUtil().loadReference()).setData(["email" : user.email, "username": user.username, "profilePicUrl": user.profilePicUrl, "bio": user.bio, "gender": user.gender, "hairTypes": user.hairTypes,  "followers": user.followerCount, "following": user.followingCount, "fbuser": user.fb], completion: { (error) in
                if error != nil{
                    print(error?.localizedDescription)
                }
            })
        }else{
        db?.collection("users").document(UserDefaultsUtil().loadReference()).setData(["email" : user.email, "username": user.username, "profilePicUrl": user.profilePicUrl, "bio": user.bio, "gender": user.gender, "hairTypes": user.hairTypes,  "followers": user.followerCount, "following": user.followingCount], completion: { (error) in
            if error != nil{
                print(error?.localizedDescription)
            }
        })
        }
    }
    
    func updateOtherUser(_ user: User){
        if user.fb != nil{
            db?.collection("users").document(user.reference).setData(["email" : user.email, "username": user.username, "profilePicUrl": user.profilePicUrl, "bio": user.bio, "gender": user.gender, "hairTypes": user.hairTypes,  "followers": user.followerCount, "following": user.followingCount, "fbuser": user.fb], completion: { (error) in
                if error != nil{
                    print(error?.localizedDescription)
                }
            })
        }else{
        db?.collection("users").document(user.reference).setData(["email" : user.email, "username": user.username, "profilePicUrl": user.profilePicUrl, "bio": user.bio, "gender": user.gender, "hairTypes": user.hairTypes,  "followers": user.followerCount, "following": user.followingCount], completion: { (error) in
            if error != nil{
                print(error?.localizedDescription)
            }
        })
        }

    }
    
    func followUser(_ user: User){
            
            // Follow
        db?.collection("users").document(user.reference).collection("followers").addDocument(data: ["user" : UserDefaultsUtil().loadReference()])
            updateFollow(user.reference)
            user.followerCount += 1
            updateOtherUser(user)
    }
    
    func unfollowUser(_ user: User){
        db?.collection("users").document(user.reference).collection("followers").getDocuments(completion: { (snapshot, error) in
            if error != nil {
                print(error?.localizedDescription)
                return
            }
            
            for i in (snapshot?.documents)!{
                let userRef = i.data()["user"] as! String
                if userRef == UserDefaultsUtil().loadReference(){
                    // Unfollow
                    if user.followerCount > 0{
                        user.followerCount -= 1
                    }
                    self.db?.collection("users").document(user.reference).collection("followers").document(i.documentID).delete()
                    self.updateUnfollow(user.reference)
                    self.updateOtherUser(user)
                }
            }
    })
    }
    
    func updateUnfollow(_ ref: String){
        let user = UserDefaultsUtil().loadUserData()
        if user.followingCount > 0{
            user.followingCount -= 1
        }else{
            user.followingCount = 0
        }
        UserDefaultsUtil().saveUserData(user)
        db?.collection("users").document(UserDefaultsUtil().loadReference()).collection("following").whereField("user", isEqualTo: ref).getDocuments(completion: { (snapshot, error) in
            if error != nil{
                print(error?.localizedDescription)
                return
            }
            
            for i in (snapshot?.documents)!{
               // Remove from Following List
                self.db?.collection("users").document(UserDefaultsUtil().loadReference()).collection("following").document(i.documentID).delete()
                
                self.updateUser(user)
            }
        })
    }
    
    func updateFollow(_ ref: String){
        let user = UserDefaultsUtil().loadUserData()
        user.followingCount += 1
        UserDefaultsUtil().saveUserData(user)
        
        // Add to Following List
        self.db?.collection("users").document(UserDefaultsUtil().loadReference()).collection("following").addDocument(data: ["user" : ref])
        
        self.updateUser(user)
    }
    
    func createPost(_ newPost: Post){
        db?.collection("posts").addDocument(data: ["user": UserDefaultsUtil().loadReference()
            ,"caption" : newPost.mCaption!, "likes": newPost.mLikes!, "comments": newPost.mComments!, "imageUrl": newPost.mImageUrl, "date": newPost.mDate, "tags": newPost.mTags])
    }
    
    func createGuide(_ newGuide: Guide){
        let reference = db?.collection("guides").addDocument(data: ["user" : UserDefaultsUtil().loadReference(), "title": newGuide.mTitle, "text": newGuide.mText, "views": 0, "comments": 0, "image": newGuide.mImageUrl, "bookmarks": 0], completion: { (error) in
            // Error
            if error != nil{
            print(error?.localizedDescription)
                return
            }
            
            
        })
        if newGuide.mProducts.count > 0{
            for i in newGuide.mProducts{
                db?.collection("guides").document((reference?.documentID)!).collection("products").addDocument(data: ["name" : i.name, "price": i.price, "image": i.imageUrl, "productUrl": i.productUrl, "ratingImg": i.ratingImg, "rating": i.rating, "shortDescription": i.shortDescription, "fullDescription": i.description])
            }
        }
        newGuide.mReference = (reference?.documentID)!
    }
    
    func createGuideContents(_ title: String, _ contents: String)-> Guide{
        let reference = db?.collection("testguides").addDocument(data: ["user" : UserDefaultsUtil().loadReference(), "title": title, "content": contents, "views": 0, "comments": 0], completion: { (error) in
            if error != nil{
                print(error?.localizedDescription)
            }
            
        })
        var newGuide = Guide(title: title, text: "", viewCount: 0, comments: 0, reference: (reference?.documentID)!)
        //newGuide.mContent = contents
        return newGuide
    }
    
    func guideViewed(_ viewedGuide: Guide){
        updateGuide(viewedGuide)
    }
    
    func bookmarkGuide(_ selectedGuide: Guide, _ isFound: Bool){
        
        if !isFound{
            selectedGuide.mBookmarks += 1
            db?.collection("users").document(UserDefaultsUtil().loadReference()).collection("bookmarks").addDocument(data: ["guide" : selectedGuide.mReference], completion: { (error) in
                if error != nil{
                    print(error?.localizedDescription)
                    return
                }
                self.updateGuide(selectedGuide)
            })
        }else{
            if selectedGuide.mBookmarks > 0{
                selectedGuide.mBookmarks -= 1
            }else{
                selectedGuide.mBookmarks = 0
            }

            db?.collection("users").document(UserDefaultsUtil().loadReference()).collection("bookmarks").whereField("guide", isEqualTo: selectedGuide.mReference).getDocuments(completion: { (snapshot, error) in
                if error != nil{
                    print(error?.localizedDescription)
                }
                
                // Delete Bookmark
                self.db?.collection("users").document(UserDefaultsUtil().loadReference()).collection("bookmarks").document((snapshot?.documents.first?.documentID)!).delete()
                
                self.updateGuide(selectedGuide)
            })
        }
    }
    
    func updateGuide(_ guide: Guide){
            db?.collection("guides").document((guide.mReference)).setData(["user" : guide.mAuthor, "title": guide.mTitle, "text": guide.mText, "views": guide.mViews, "comments": guide.mComments, "image": guide.mImageUrl, "bookmarks": guide.mBookmarks], completion: { (error) in
            if error != nil{
                print(error?.localizedDescription)
                return
            }
            
        })
        
        if guide.mProducts.count > 0{
            for i in guide.mProducts{
                db?.collection("guides").document(guide.mReference).collection("products").addDocument(data: ["name" : i.name, "price": i.price, "image": i.imageUrl, "productUrl": i.productUrl, "ratingImg": i.ratingImg, "rating": i.rating, "shortDescription": i.shortDescription, "fullDescription": i.description])
            }
        }
    }
    
    func addComment(_ postRef: String, _ comment: Comment, _ collectionView: UICollectionView){
       let reference = db?.collection("posts").document(postRef).collection("comments").addDocument(data: ["text" : comment.text, "date": comment.date, "user": comment.user], completion: { (error) in
            if error != nil{
                print(error?.localizedDescription)
                return
            }
        DispatchQueue.main.async {
            collectionView.reloadData()
        }
            
        })
        
        comment.ref = (reference?.documentID)!
    }
}
