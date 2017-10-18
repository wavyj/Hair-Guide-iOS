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
    
    func createPost(_ newPost: Post){
       db?.collection("users").document(UserDefaultsUtil().loadReference()).collection("posts").addDocument(data: ["caption" : newPost.mCaption!,
                                                                                                                   "likes": newPost.mLikes!,
                                                                                                                   "comments": newPost.mComments!,
                                                                                                                   "imageUrl": newPost.mImageUrl])
    }
    
    /*func createGuide(_ newGuide: Guide){
        
    }*/
}
