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
    let mTitle: String
    let mText: String
    var mViews: Int
    let mComments: Int 
    var mReference: DocumentReference? = nil
    
    init(title: String, text: String, viewCount: Int, comments: Int, reference: DocumentReference){
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
