//
//  UserDefaultsUtil.swift
//  ColemanJustin_FinalProject
//
//  Created by Justin Coleman on 10/12/17.
//  Copyright © 2017 Justin Coleman. All rights reserved.
//

import Foundation

class UserDefaultsUtil{
    
    init() {
   
    }
    
    public func saveUser(_ email: String, _ password: String){
        UserDefaults.standard.set(email, forKey: "userEmail")
        UserDefaults.standard.set(password, forKey: "userPassword")
    }
    
    public func loadUserEmail() -> String?{
        return UserDefaults.standard.object(forKey: "userEmail") as? String
    }
    
    public func loadUserPassword() -> String?{
        return UserDefaults.standard.object(forKey: "userPassword") as? String
    }
    
    public func saveReference(DocumentID: String){
        UserDefaults.standard.set(DocumentID, forKey: "dbReference")
    }
    
    public func loadReference() -> String{
        return UserDefaults.standard.object(forKey: "dbReference") as! String
    }
    
    public func saveUserData(_ user: User){
        UserDefaults.standard.set(user.username, forKey: "username")
        UserDefaults.standard.set(user.email, forKey: "email")
        UserDefaults.standard.set(user.bio, forKey: "bio")
        UserDefaults.standard.set(user.profilePicUrl, forKey: "profilePicUrl")
        UserDefaults.standard.set(user.gender, forKey: "gender")
        UserDefaults.standard.set(user.followerCount, forKey: "followers")
        UserDefaults.standard.set(user.followingCount, forKey: "following")
        UserDefaults.standard.set(user.hairTypes, forKey: "hairTypes")
        
    }
    
    public func loadUserData() -> User{
        let username = UserDefaults.standard.object(forKey: "username") as! String
        let email = UserDefaults.standard.object(forKey: "email") as! String
        let bio = UserDefaults.standard.object(forKey: "bio") as! String
        let profilePicUrl = UserDefaults.standard.object(forKey: "profilePicUrl") as! String
        let gender = UserDefaults.standard.object(forKey: "gender") as! String
        let followers = UserDefaults.standard.object(forKey: "followers") as! Int
        let following = UserDefaults.standard.object(forKey: "following") as! Int
        let user = User(email: email, username: username, bio: bio, profilePicUrl: profilePicUrl, gender: gender)
        let types = UserDefaults.standard.object(forKey: "hairTypes") as! [String]
        user.followerCount = followers
        user.followingCount = following
        return user
    }
    
    public func saveFBData(_ data: [String]){
        UserDefaults.standard.set(data[0], forKey: "fbID")
        UserDefaults.standard.set(data[1], forKey: "fbName")
        UserDefaults.standard.set(data[2], forKey: "fbImage")
    }
    
    public func loadFBData()-> [String]{
        let id = UserDefaults.standard.object(forKey: "fbID") as! String
        let name = UserDefaults.standard.object(forKey: "fbName") as! String
        let url = UserDefaults.standard.object(forKey: "fbImage") as! String
        return [id, name, url]
    }
    
    public func checkFB()-> Bool{
        if UserDefaults.standard.object(forKey: "fbID") != nil{
            return true
        }else{
            return false
        }
    }
    
    public func signOutFB(){
        UserDefaults.standard.removeObject(forKey: "fbID")
        UserDefaults.standard.removeObject(forKey: "fbName")
        UserDefaults.standard.removeObject(forKey: "fbImage")
    }
    
    public func signOut(){
        // Remove all Defaults
        UserDefaults.standard.removeObject(forKey: "userEmail")
        UserDefaults.standard.removeObject(forKey: "userPassword")
        UserDefaults.standard.removeObject(forKey: "username")
        UserDefaults.standard.removeObject(forKey: "email")
        UserDefaults.standard.removeObject(forKey: "bio")
        UserDefaults.standard.removeObject(forKey: "profilePicUrl")
        UserDefaults.standard.removeObject(forKey: "gender")
        UserDefaults.standard.removeObject(forKey: "dbReference")
        UserDefaults.standard.removeObject(forKey: "hairTypes")
        UserDefaults.standard.removeObject(forKey: "followers")
        UserDefaults.standard.removeObject(forKey: "following")
    }
    
}
