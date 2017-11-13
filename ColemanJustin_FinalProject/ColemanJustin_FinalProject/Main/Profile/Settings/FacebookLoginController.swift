//
//  FacebookLoginController.swift
//  ColemanJustin_FinalProject
//
//  Created by Justin Coleman on 11/12/17.
//  Copyright © 2017 Justin Coleman. All rights reserved.
//

import UIKit
import MaterialComponents
import FBSDKLoginKit

class FacebookLoginController: UIViewController, FBSDKLoginButtonDelegate {

    
    //MARK: - Outlets
    @IBOutlet weak var facebookBtn: FBSDKLoginButton!
    @IBOutlet weak var userInfoView: UIView!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    //MARK: - Variables
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupMaterialComponents()
        facebookBtn.readPermissions = ["public_profile"]
        facebookBtn.delegate = self
        if let accessToken = FBSDKAccessToken.current(){
            getFBData()
         }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Facebook Login Callbacks
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil{
            print(error.localizedDescription)
            return
        }
        userInfoView.isHidden = true
        self.getFBData()
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        userInfoView.isHidden = true
    }
    
    //MARK: - Methods
    func setupMaterialComponents(){
        // AppBar Setup
        let appBar = MDCAppBar()
        title = "Facebook"
        self.addChildViewController(appBar.headerViewController)
        appBar.headerViewController.headerView.clipsToBounds = false
        appBar.headerViewController.headerView.layer.shadowOffset = CGSize(width: 0, height: 1)
        appBar.headerViewController.headerView.layer.shadowOpacity = 0.3
        appBar.headerViewController.headerView.layer.shadowRadius = 3
        appBar.headerViewController.headerView.backgroundColor = UIColor.white
        appBar.navigationBar.tintColor = MDCPalette.blueGrey.tint900
        appBar.addSubviewsToParent()
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
                    DispatchQueue.main.async {
                        self.userInfoView.isHidden = false
                        self.userInfoView.layer.masksToBounds = true
                        self.userInfoView.layer.cornerRadius = 6
                        self.profilePic.layer.masksToBounds = true
                        self.profilePic.layer.cornerRadius = 6
                        self.userNameLabel.text = name
                        self.profilePic.pin_setImage(from: URL(string: url))
                        self.profilePic.pin_updateWithProgress = true
                    }
                    UserDefaultsUtil().saveFBData([id, name, url])
                }
                
            })
        }
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
