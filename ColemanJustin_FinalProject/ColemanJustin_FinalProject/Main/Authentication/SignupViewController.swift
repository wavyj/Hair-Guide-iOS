//
//  SignupViewController.swift
//  ColemanJustin_FinalProject
//
//  Created by Justin Coleman on 10/11/17.
//  Copyright © 2017 Justin Coleman. All rights reserved.
//

import UIKit
import Firebase
import MaterialComponents
import Validator

class SignupViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: - Outlets
    @IBOutlet weak var emailField: MDCTextField!
    @IBOutlet weak var passwordField: MDCTextField!
    @IBOutlet weak var confirmPassField: MDCTextField!
    @IBOutlet weak var enterBtn: MDCRaisedButton!
    
    //MARK: - Variables
    var auth: Auth? = nil
    var handler: AuthStateDidChangeListenerHandle? = nil
    var textFieldControllers = [MDCTextInputControllerDefault]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // Material Components Setup
        setupMaterialComponents()
        
        // Authentication
        auth = Auth.auth()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: - Storyboard Actions
    @IBAction func backTapped(_ sender: UIBarButtonItem){
        performSegue(withIdentifier: "unwindSignup", sender: sender)
    }
    
    func submitTapped(_ sender: UIButton){
        print("Submit Tapped")
        
        // Input Validation
        if (validateInput()){
            // Create Account
            auth?.createUser(withEmail: emailField.text!, password: passwordField.text!, completion: { (user, error) in
                if (error != nil){
                    // Error
                    print(error?.localizedDescription)
                    var alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                    alert.addAction(okAction)
                    if error?.localizedDescription == "The email address is already in use by another account."{
                        alert.title = "Email is Taken"
                        alert.message = "There is already an account created with that email address."
                    }
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                
                let u = User(email: self.emailField.text!, username: "", bio: "", profilePicUrl: "", gender: "")
                
                UserDefaultsUtil().saveUser(u.email, self.passwordField.text!)
                UserDefaultsUtil().saveUserData(u)
                
                // Save User to database
                DatabaseUtil().createUser(u)
                
                self.segue()
            })
        }
    }

    //MARK: - Methods
    func setupMaterialComponents(){
        
        // Material Components Setup
        enterBtn.setTitleColor(MDCPalette.grey.tint100, for: .normal)
        enterBtn.setTitle("Submit", for: .normal)
        enterBtn.setBackgroundColor(MDCPalette.blue.tint500, for: .normal)
        enterBtn.addTarget(self, action: #selector(submitTapped(_:)), for: .touchUpInside)
        
        for i in [emailField, passwordField, confirmPassField]{
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
        title = "Create Account"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back-arrow"), style: .plain, target: self, action: #selector(backTapped(_:)))
        appBar.addSubviewsToParent()
    }
    
    //MARK: - TextField Delegate Callbacks
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case 0:
            validateEmail(textField)
            break
        case 1:
            validateCharCount(textField)
            break
        case 2:
            validateCharCount(textField)
            break
        case 3:
            let b = validateCharCount(textField)
            if (b){
            validatePasswordsMatch()
            }
            break
        default:
            break
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textFieldControllers[textField.tag].setErrorText(nil, errorAccessibilityValue: nil)
    }
    
    func validateEmail(_ textField: UITextField) -> Bool{
        // Email
        let emailRule = ValidationRulePattern(pattern: EmailValidationPattern.standard, error: ValidationError(message: "Invalid Email"))
        let result = emailField.validate(rule: emailRule)
        switch result{
        case .valid:
            textFieldControllers[textField.tag].setErrorText(nil, errorAccessibilityValue: nil)
            return true
        case .invalid( _):
            textFieldControllers[textField.tag].setErrorText("Invalid Email", errorAccessibilityValue: "Invalid Email")
            return false
        }
    }
    
    func validateCharCount(_ textField: UITextField) -> Bool{
        // Character Count
        let charCountRule = ValidationRuleLength(min: 6, max: 14, lengthType: .characters, error: ValidationError(message: "Wrong amount of characters"))
        
            let r = textField.validate(rule: charCountRule)
            switch r{
            case .valid:
                textFieldControllers[textField.tag].setErrorText(nil, errorAccessibilityValue: nil)
                return true
            case .invalid( _):
                var errorText = ""
                if (textField.text?.characters.count)! < 6{
                    errorText = "Too short"
                }else{
                    errorText = "Too long"
                }
                textFieldControllers[textField.tag].setErrorText(errorText, errorAccessibilityValue: errorText)
                return false
            }
        }
    
    func validatePasswordsMatch() -> Bool{
        // Passwords Match
        let passwordRule = ValidationRuleEquality(target: passwordField.text!, error: ValidationError(message: "Passwords Don't Match"))
        let r = confirmPassField.validate(rule: passwordRule)
        
        switch r {
        case .valid:
            textFieldControllers[1].setErrorText(nil, errorAccessibilityValue: nil)
            textFieldControllers[2].setErrorText(nil, errorAccessibilityValue: nil)
            return true
        case .invalid(_):
            textFieldControllers[1].setErrorText("Passwords Don't Match", errorAccessibilityValue: "Passwords Don't Match")
            textFieldControllers[2].setErrorText("Passwords Don't Match", errorAccessibilityValue: "Passwords Don't Match")
            return false
        }
    }
    
    func validateInput() -> Bool{
        var isValid = true
        var tempBool = true
        
        // Email
        tempBool = validateEmail(emailField)
        if (tempBool == false){
            isValid = tempBool
        }
        
        // Character Count
        for i in [passwordField, confirmPassField]{
            tempBool = validateCharCount(i!)
            
            if (tempBool == false){
                isValid = tempBool
            }
        }
        
        // Passwords Match
        tempBool = validatePasswordsMatch()
        if (tempBool == false){
            isValid = tempBool
        }
        
        return isValid
    }
    
    func segue(){
        performSegue(withIdentifier: "toAnalysis", sender: self)
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
