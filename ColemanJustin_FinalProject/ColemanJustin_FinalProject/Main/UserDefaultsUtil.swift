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
    
    public func saveUser(token: String){
        UserDefaults.standard.set(token, forKey: "userToken")
        UserDefaults.standard.set(true, forKey: "loggedIn")
    }
    
    public func loadUser() -> String{
        return UserDefaults.standard.object(forKey: "userToken") as! String
    }
    
    public func checkStatus() -> Bool{
        return UserDefaults.standard.bool(forKey: "loggedIn")
    }
    
}
