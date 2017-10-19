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
    
    public func initialLoad(){
        UserDefaults.standard.set(false, forKey: "loggedIn")
    }
    
    public func loadUser() -> String{
        return UserDefaults.standard.object(forKey: "userToken") as! String
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
    
    public func checkStatus() -> Bool{
        return UserDefaults.standard.bool(forKey: "loggedIn")
    }
    
    public func saveReference(DocumentID: String){
        UserDefaults.standard.set(true, forKey: "loggedIn")
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
    }
    
    public func loadUserData() -> User{
        let username = UserDefaults.standard.object(forKey: "username") as! String
        let email = UserDefaults.standard.object(forKey: "email") as! String
        let bio = UserDefaults.standard.object(forKey: "bio") as! String
        let profilePicUrl = UserDefaults.standard.object(forKey: "profilePicUrl") as! String
        let gender = UserDefaults.standard.object(forKey: "gender") as! String
        return User(email: email, username: username, bio: bio, profilePicUrl: profilePicUrl, gender: gender)
    }
    
}
