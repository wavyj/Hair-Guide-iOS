//
//  User.swift
//  ColemanJustin_FinalProject
//
//  Created by Justin Coleman on 10/17/17.
//  Copyright © 2017 Justin Coleman. All rights reserved.
//

import Foundation
import UIKit
import ImageButter

class User{
    var email: String
    var username: String
    var bio: String
    var profilePicUrl: String
    var profilePic: WebPImage? = nil
    var gender: String
    var hairTypes: [String] = [String]()
    var followerCount = 0
    var followingCount = 0
    
    init(email: String, username: String, bio: String, profilePicUrl: String, gender: String) {
        self.email = email
        self.username = username
        self.bio = bio
        self.profilePicUrl = profilePicUrl
        self.gender = gender
    }
}
