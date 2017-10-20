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
    var mImage: UIImage? = nil
    let mLikes: Int?
    let mComments: Int?
    let mDate: Date?
    var mImageUrl: String = ""
    var mTags: [String]?
    var mReference: DocumentReference? = nil
    
    
    init(caption: String, image: UIImage, likes: Int, comments: Int){
        mCaption = caption
        mImage = image
        mLikes = likes
        mComments = comments
        mDate = Date()
    }
    
    init(caption: String, likes: Int, comments: Int, date: Date, imageUrl: String, tags: [String]){
        mCaption = caption
        mLikes = likes
        mComments = comments
        mDate = date
        mTags = tags
        mImageUrl = imageUrl
        //downloadImage()
    }
    
    func setImageUrl(_ imageURl: String){
        mImageUrl = imageURl
        
        // Save to Database
        DatabaseUtil().createPost(self)
    }
    
    func downloadImage(_ collection: UICollectionView){
        CloudStorageUtil().downloadImage(mImageUrl, self, collection)
    }
    
    func getDate()-> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM dd, HH:mm"
        return formatter.string(from: mDate!)
    }
}
