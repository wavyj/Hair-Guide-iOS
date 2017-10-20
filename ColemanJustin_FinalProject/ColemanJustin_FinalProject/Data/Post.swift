//
//  Post.swift
//  ColemanJustin_FinalProject
//
//  Created by Justin Coleman on 10/12/17.
//  Copyright © 2017 Justin Coleman. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class Post{
    let mCaption: String?
    let mImage: UIImage?
    let mLikes: Int?
    let mComments: Int?
    var mImageUrl: String = ""
    var mReference: DocumentReference? = nil
    
    init(caption: String, image: UIImage, likes: Int, comments: Int){
        mCaption = caption
        mImage = image
        mLikes = likes
        mComments = comments
    }
    
    func setImageUrl(_ imageURl: String){
        mImageUrl = imageURl
        
        // Save to Database
        DatabaseUtil().createPost(self)
    }
}
