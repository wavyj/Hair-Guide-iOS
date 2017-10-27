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
            UserDefaultsUtil().saveUserData(user)
        })
        
    }
    
    func updateUser(_ user: User){
        db?.collection("users").document(UserDefaultsUtil().loadReference()).setData(["email" : user.email, "username": user.username, "profilePicUrl": user.profilePicUrl, "bio": user.bio, "gender": user.gender, "hairTypes": user.hairTypes,  "followers": user.followerCount, "following": user.followingCount], completion: { (error) in
            if error != nil{
                print(error?.localizedDescription)
            }
        })
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
        
        newGuide.mReference = reference
    }
    
    func createGuideContents(_ title: String, _ contents: String)-> Guide{
        let reference = db?.collection("testguides").addDocument(data: ["user" : UserDefaultsUtil().loadReference(), "title": title, "content": contents, "views": 0, "comments": 0], completion: { (error) in
            if error != nil{
                print(error?.localizedDescription)
            }
            
        })
        var newGuide = Guide(title: title, text: "", viewCount: 0, comments: 0, reference: reference!)
        //newGuide.mContent = contents
        return newGuide
    }
    
    func guideViewed(_ viewedGuide: Guide){
        updateGuide(viewedGuide)
    }
    
    func saveHairTypes(_ types: [String]){
        let newUser = UserDefaultsUtil().loadUserData()
        db?.collection("users").document(UserDefaultsUtil().loadReference()).setData(["email" : newUser.email, "username": newUser.username, "profilePicUrl": newUser   .profilePicUrl, "bio": newUser.bio, "gender": newUser.gender, "hairTypes": types, "followers": newUser.followerCount, "following": newUser.followingCount])
    }
    
    func bookmarkGuide(_ selectedGuide: Guide, _ isFound: Bool){
        
        if !isFound{
            selectedGuide.mBookmarks += 1
            db?.collection("users").document(UserDefaultsUtil().loadReference()).collection("bookmarks").addDocument(data: ["guide" : selectedGuide.mReference?.documentID], completion: { (error) in
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

            db?.collection("users").document(UserDefaultsUtil().loadReference()).collection("bookmarks").whereField("guide", isEqualTo: selectedGuide.mReference?.documentID).getDocuments(completion: { (snapshot, error) in
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
        db?.collection("guides").document((guide.mReference?.documentID)!).setData(["user" : guide.mAuthor, "title": guide.mTitle, "text": guide.mText, "views": guide.mViews, "comments": guide.mComments, "image": guide.mImageUrl, "bookmarks": guide.mBookmarks], completion: { (error) in
            if error != nil{
                print(error?.localizedDescription)
                return
            }
        })
    }
}
