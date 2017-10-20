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
         "gender": ""], completion: { (error) in
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
            UserDefaultsUtil().saveUserData(User(email: email, username: username, bio: bio, profilePicUrl: pic, gender: gender))
        })
        
    }
    
    func createPost(_ newPost: Post){
        db?.collection("posts").addDocument(data: ["user": UserDefaultsUtil().loadReference()
            ,"caption" : newPost.mCaption!, "likes": newPost.mLikes!, "comments": newPost.mComments!, "imageUrl": newPost.mImageUrl, "date": newPost.mDate, "tags": newPost.mTags])
    }
    
    func createGuide(_ newGuide: Guide){
        let reference = db?.collection("guides").addDocument(data: ["user" : UserDefaultsUtil().loadReference(), "title": newGuide.mTitle, "text": newGuide.mText, "views": 0, "comments": 0], completion: { (error) in
            // Error
            if error != nil{
            print(error?.localizedDescription)
            }
        })
        
        newGuide.mReference = reference
    }
    
    func guideViewed(_ viewedGuide: Guide){
        db?.collection("guides").document((viewedGuide.mReference?.documentID)!).setData(["user" : UserDefaultsUtil().loadReference(), "title": viewedGuide.mTitle, "text": viewedGuide.mText, "views": viewedGuide.mViews, "comments": 0])
    }
    
    func saveHairTypes(_ types: [String]){
        let newUser = UserDefaultsUtil().loadUserData()
        db?.collection("users").document(UserDefaultsUtil().loadReference()).setData(["email" : newUser.email, "username": newUser.username, "profilePicUrl": newUser   .profilePicUrl, "bio": newUser.bio, "gender": newUser.gender, "hairTypes": types])
    }
}
