//
//  SplashScreen.swift
//  ColemanJustin_FinalProject
//
//  Created by Justin Coleman on 10/19/17.
//  Copyright © 2017 Justin Coleman. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit

class SplashScreen: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //Check if logged in
        if UserDefaultsUtil().loadUserEmail() != nil{
            login()
        }else if FBSDKAccessToken.current() != nil{
            fbLogin()
        }else{
            DispatchQueue.main.async {
                self.toAuth()
            }
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func login(){
        Auth.auth().signIn(withEmail: UserDefaultsUtil().loadUserEmail()!, password: UserDefaultsUtil().loadUserPassword()!) { (user, error) in
            if error != nil{
                // Error
                print(error?.localizedDescription)
                return
            }
            
            self.toFeed()
        }
    }
    
    func fbLogin(){
        let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        Auth.auth().signIn(with: credential) { (user, error) in
            if error != nil{
                print(error?.localizedDescription)
                return
            }
            self.toFeed()
        }
    }
    
    func toFeed(){
        performSegue(withIdentifier: "toFeed", sender: self)
    }
    
    func toAuth(){
        performSegue(withIdentifier: "toAuth", sender: self)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
