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

class AuthenticationViewController: UIViewController {

    //MARK: - Outlets

    @IBOutlet weak var signupBtn: MDCFlatButton!
    @IBOutlet weak var loginBtn: MDCFlatButton!
    @IBOutlet weak var instagramBtn: MDCRaisedButton!
    
    //MARK: - Variables

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Setup Material Components
        setupMaterialComponents()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Storyboard Actions
    @objc func loginTapped(_ sender: UIButton){
        print("Login Tapped")
        performSegue(withIdentifier: "toLogin", sender: sender)
    }
    
    @objc func signupTapped(_ sender: UIButton){
        print("Signup Tapped")
        
        performSegue(withIdentifier: "toSignup", sender: sender)
    }
    
    @objc func instagramTapped(_sender: UIButton){
        
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
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
 

}
