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
import DateToolsSwift

class Post{
    let mCaption: String?
    var mImage: UIImage? = nil
    var mImageAlt: UIImage? = nil
    let mLikes: Int?
    let mComments: Int?
    let mDate: Date?
    var mImageUrl: String = ""
    var mTags: [String]?
    var mReference: DocumentReference? = nil
    var mUser: User? = nil
    
    init(caption: String, image: UIImage, likes: Int, comments: Int){
        mCaption = caption
        mLikes = likes
        mComments = comments
        mDate = Date()
        mImage = image
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
    
    var dateString: String{
        return (mDate?.shortTimeAgoSinceNow)!
    }
    
    func setImageUrl(_ imageURl: String){
        mImageUrl = imageURl
        
        // Save to Database
        DatabaseUtil().createPost(self)
    }
    
    func getDate()-> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM dd, HH:mm"
        return formatter.string(from: mDate!)
    }
}
