//
//  AuthenticationViewController.swift
//  ColemanJustin_FinalProject
//
//  Created by Justin Coleman on 10/11/17.
//  Copyright © 2017 Justin Coleman. All rights reserved.
//

import UIKit
import MaterialComponents

class AuthenticationViewController: UIViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var loginContainer: UIView!
    @IBOutlet weak var signupContainer: UIView!
    @IBOutlet weak var facebookContainer: UIView!
    
    //MARK: - Variables

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Create Material Components Buttons
        let loginBtn = MDCFlatButton()
        loginBtn.setTitleColor(MDCPalette.blue.tint400, for: .normal)
        loginBtn.setTitle("Login", for: .normal)
        loginBtn.sizeToFit()
        loginBtn.center = CGPoint(x: loginContainer.bounds.width / 2, y: loginContainer.bounds.height / 2)
        loginBtn.addTarget(self, action: #selector(loginTapped(_:)) , for: .touchUpInside)
        loginContainer.addSubview(loginBtn)
        
        let signupBtn = MDCFlatButton()
        signupBtn.setTitleColor(MDCPalette.blue.tint400, for: .normal)
        signupBtn.setTitle("Signup", for: .normal)
        signupBtn.sizeToFit()
        signupBtn.center = CGPoint(x: signupContainer.bounds.width / 2, y: signupContainer.bounds.height / 2)
        signupBtn.addTarget(self, action: #selector(signupTapped(_:)) , for: .touchUpInside)
        signupContainer.addSubview(signupBtn)
        
        let facebookBtn = MDCRaisedButton()
        facebookBtn.setTitleColor(MDCPalette.grey.tint50, for: .normal)
        facebookBtn.setTitle("Log In With Facebook", for: .normal)
        facebookBtn.setBackgroundColor(MDCPalette.blue.tint800)
        facebookBtn.sizeToFit()
        facebookBtn.center = CGPoint(x: facebookContainer.bounds.width / 2, y: facebookContainer.bounds.height / 2)
        facebookBtn.addTarget(self, action: #selector(facebookTapped(_:)) , for: .touchUpInside)
        facebookContainer.addSubview(facebookBtn)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - Storyboard Actions
    func loginTapped(_ sender: UIButton){
        print("Login Tapped")
    }
    
    func signupTapped(_ sender: UIButton){
        print("Signup Tapped")
        
        performSegue(withIdentifier: "toSignup", sender: sender)
    }
    
    func facebookTapped(_ sender: UIButton){
        print("Facebook Tapped")
    }
    
    @IBAction func unwind(_ sender: UIStoryboardSegue){
        
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
