//
//  AuthenticationViewController.swift
//  ColemanJustin_FinalProject
//
//  Created by Justin Coleman on 10/11/17.
//  Copyright © 2017 Justin Coleman. All rights reserved.
//

import UIKit
import MaterialComponents
import Firebase
import FBSDKLoginKit

class AuthenticationViewController: UIViewController, FBSDKLoginButtonDelegate {

    //MARK: - Outlets

    @IBOutlet weak var signupBtn: MDCFlatButton!
    @IBOutlet weak var loginBtn: MDCFlatButton!
    @IBOutlet weak var facebookBtn: FBSDKLoginButton!
    @IBOutlet weak var instagramBtn: MDCRaisedButton!
    
    //MARK: - Variables

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Setup Material Components
        setupMaterialComponents()
        facebookBtn.readPermissions = ["public_profile"]
        facebookBtn.delegate = self
        /*if let accessToken = FBSDKAccessToken.current(){
            getFBData()
        }*/
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - FBSDK Login Button Callbacks
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil{
            print("Error: " + error.localizedDescription)
            return
        }
        let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        Auth.auth().signIn(with: credential) { (user, error) in
            if error != nil{
                print("Error: " + (error?.localizedDescription)!)
                return
            }
            self.getFBData()
            
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
    }

    
    //MARK: - Storyboard Actions
    func loginTapped(_ sender: UIButton){
        print("Login Tapped")
        performSegue(withIdentifier: "toLogin", sender: sender)
    }
    
    func signupTapped(_ sender: UIButton){
        print("Signup Tapped")
        
        performSegue(withIdentifier: "toSignup", sender: sender)
    }
    
    func instagramTapped(_sender: UIButton){
        
    }
    
    @IBAction func unwind(_ sender: UIStoryboardSegue){
        
    }
    
    //MARK: - Methods
    func setupMaterialComponents(){
        // Create Material Components Buttons
        loginBtn.setTitleColor(MDCPalette.blue.tint400, for: .normal)
        loginBtn.setTitle("Login", for: .normal)
        loginBtn.addTarget(self, action: #selector(loginTapped(_:)) , for: .touchUpInside)
        
        signupBtn.setTitleColor(MDCPalette.blue.tint400, for: .normal)
        signupBtn.setTitle("Create Account", for: .normal)
        signupBtn.addTarget(self, action: #selector(signupTapped(_:)) , for: .touchUpInside)
        
        instagramBtn.setTitleColor(MDCPalette.blue.tint400, for: .normal)
        instagramBtn.setTitle("Connect Instagram", for: .normal)
        instagramBtn.addTarget(self, action: #selector(instagramTapped(_sender:)), for: .touchUpInside)
    }
    
    
    
    func getFBData(){
        if FBSDKAccessToken.current() != nil{
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) in
                if error != nil{
                    print(error?.localizedDescription)
                    return
                }
                if let results = result as? [String: AnyObject]{
                    print(results)
                    let id = results["id"] as! String
                    let name = results["name"] as! String
                    let picObj = results["picture"] as! [String: AnyObject]
                    let data = picObj["data"] as! [String: AnyObject]
                    let url = data["url"] as! String
                    UserDefaultsUtil().saveFBData([id, name, url])
                    self.checkFbUser()
                }
                
            })
        }
    }
    
    func checkFbUser(){
        let db = Firestore.firestore()
        db.collection("users").whereField("fbuser", isEqualTo: FBSDKAccessToken.current().tokenString).getDocuments { (snapshot, error) in
            if error != nil{
                print(error?.localizedDescription)
                return
            }
    
            for i in (snapshot?.documents)!{
                let data = i.data()
                let fbToken = data["fbuser"] as! String
                print(fbToken)
                if fbToken == FBSDKAccessToken.current().tokenString{
                    // Get User
                    DatabaseUtil().getFbUser(FBSDKAccessToken.current().tokenString)
                    print("Existing User")
                    return
                }
            }
            // Create New User
            print("New User")
            let u = User(email: "", username: "", bio: "", profilePicUrl: "", gender: "")
            UserDefaultsUtil().saveReference(DocumentID: "")
            UserDefaultsUtil().saveUserData(u)
            self.performSegue(withIdentifier: "toAnalysis", sender: self)
        }
    }
    
    //MARK: - Instagram Delegate Callbacks
    func authControllerDidFinish(accessToken: String?, error: NSError?) {
        if error != nil{
            print(error?.localizedDescription)
            return
        }
        print(accessToken)
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
 

}
