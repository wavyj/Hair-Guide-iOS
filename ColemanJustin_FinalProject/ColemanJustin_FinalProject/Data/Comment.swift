//
//  Comment.swift
//  ColemanJustin_FinalProject
//
//  Created by Justin Coleman on 11/2/17.
//  Copyright © 2017 Justin Coleman. All rights reserved.
//

import Foundation

class Comment{
    let text: String
    var ref: String = ""
    let user: String
    let date: Date
    var mUser: User? = nil
    
    init(text: String, date: Date, ref: String, user: String) {
        self.text = text
        self.date = date
        self.ref = ref
        self.user = user
    }
    
    var dateString: String{
        return (date.shortTimeAgo(since: date))
    }
}
