//
//  Guide.swift
//  ColemanJustin_FinalProject
//
//  Created by Justin Coleman on 10/17/17.
//  Copyright © 2017 Justin Coleman. All rights reserved.
//

import Foundation
import Firebase

class Guide{
    var mTitle: String
    var mText: String
    var mViews: Int
    //var mContent: String = ""
    var mImageUrl: String = ""
    var mComments: Int
    var mReference = ""
    var mAuthor = ""
    var mBookmarks: Int = 0
    var mProducts = [Product]()
    var mUser: User? = nil
    
    init(title: String, text: String, viewCount: Int, comments: Int, reference: String){
        mTitle = title
        mText = text
        mViews = viewCount
        mComments = comments
        mReference = reference
    }
    
    init(title: String, text: String, viewCount: Int, comments: Int){
        mTitle = title
        mText = text
        mViews = viewCount
        mComments = comments
    }
}
