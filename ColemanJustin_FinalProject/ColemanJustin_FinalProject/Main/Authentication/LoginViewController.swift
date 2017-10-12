//
//  LoginViewController.swift
//  ColemanJustin_FinalProject
//
//  Created by Justin Coleman on 10/11/17.
//  Copyright © 2017 Justin Coleman. All rights reserved.
//

import UIKit
import MaterialComponents
import Firebase

class LoginViewController: UIViewController, UITextFieldDelegate {

    //MARK: - Outlets
    @IBOutlet weak var emailField: MDCTextField!
    @IBOutlet weak var passwordField: MDCTextField!
    @IBOutlet weak var submitBtn: MDCRaisedButton!
    
    //MARK: - Variables
    var auth: Auth? = nil
    var handler: AuthStateDidChangeListenerHandle? = nil
    var textFieldControllers = [MDCTextInputControllerDefault]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setupMaterialComponents()
        
        auth = Auth.auth()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        handler = auth?.addStateDidChangeListener({ (Auth, user) in
            
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Storyboard Actions
    func submitTapped(_ sender: UIButton){
        print("Submit Tapped")
    }
    
    @IBAction func backTapped(_ sender: UIBarButtonItem){
        performSegue(withIdentifier: "unwindLogin", sender: self)
    }
    
    //MARK: - Input Validation
    
    
    //MARK: - Methods
    func setupMaterialComponents(){
        submitBtn.setTitleColor(MDCPalette.blue.tint500, for: .normal)
        submitBtn.setTitle("Submit", for: .normal)
        submitBtn.addTarget(self, action: #selector(submitTapped(_:)), for: .touchUpInside)
        
        for i in [emailField, passwordField]{
            i?.delegate = self
            textFieldControllers.append(MDCTextInputControllerDefault(textInput: i))
        }
        
        for i in textFieldControllers{
            i.activeColor = MDCPalette.blue.tint500
            
        }
        
        // AppBar Setup
        let appBar = MDCAppBar()
        self.addChildViewController(appBar.headerViewController)
        appBar.headerViewController.headerView.backgroundColor = MDCPalette.grey.tint100
        appBar.navigationBar.tintColor = MDCPalette.blueGrey.tint900
        title = "Login"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back-arrow"), style: .plain, target: self, action: #selector(backTapped(_:)))
        appBar.addSubviewsToParent()
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
