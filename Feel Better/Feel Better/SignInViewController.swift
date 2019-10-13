//
//  SignInViewController.swift
//  Feel Better
//
//  Created by Kevin Tong on 2019/10/13.
//  Copyright © 2019 Feel Better. All rights reserved.
//

import UIKit
import Firebase


class SignInViewController: UIViewController {

    // MARK: Properties
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    
    @IBOutlet weak var signButton: UIButton!
    
    var hasAccount = false
    
    // MARK: Methods
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set appearances of fields
        nameField.layer.borderColor = UIColor.blue.cgColor
        nameField.layer.borderWidth = 1.0
        emailField.layer.borderColor = UIColor.blue.cgColor
        emailField.layer.borderWidth = 1.0
        passwordField.layer.borderColor = UIColor.blue.cgColor
        passwordField.layer.borderWidth = 1.0
        confirmPassword.layer.borderColor = UIColor.blue.cgColor
        confirmPassword.layer.borderWidth = 1.0
        
        passwordField.isSecureTextEntry = true
        confirmPassword.isSecureTextEntry = true
    
    }
    
    @IBAction func selectSignIn(_ sender: Any) {
        
        hasAccount = true
        
        confirmPassword.isHidden = true
        passwordField.isHidden = true
        
        nameField.placeholder = "Email"
        emailField.placeholder = "Password"
        
        emailField.isSecureTextEntry = true
        
        nameField.text = ""
        emailField.text = ""
        
        signButton.setTitle("Sign In", for: .normal)
    }
    
    @IBAction func selectSignUp(_ sender: Any) {
        
        hasAccount = false
        
        confirmPassword.isHidden = false
        passwordField.isHidden = false
        
        passwordField.isSecureTextEntry = true
        confirmPassword.isSecureTextEntry = true
        
        nameField.text = ""
        emailField.text = ""
        passwordField.text = ""
        confirmPassword.text = ""
        
        nameField.placeholder = "First Name Last Name"
        emailField.placeholder = "Email"
        
        signButton.setTitle("Create Account", for: .normal)
        
    }
    
    
    @IBAction func sign(_ sender: Any){
        
        if hasAccount{
            
            if !nameField.text!.isEmpty && !emailField.text!.isEmpty{
                Auth.auth().signIn(withEmail: nameField.text!, password: emailField.text!) { [weak self] user, error in
                    guard self != nil else { return }
                    print("error \(error!)")
                }
            }
            
            dismiss(animated: true, completion: nil)
            //self.performSegue(withIdentifier: "unwindToHome", sender: self)
            
            
            
        }else{
            if !emailField.text!.isEmpty && !passwordField.text!.isEmpty && !confirmPassword.text!.isEmpty{
                if passwordField.text == confirmPassword.text{
                    print("yay")
                    Auth.auth().createUser(withEmail: emailField.text!, password: passwordField.text!) { authResult, error in
                      print("error \(error!)")
                    }
                }
            }
            dismiss(animated: true, completion: nil)
            
                //self.performSegue(withIdentifier: "unwindToHome", sender: self)
            
            
        }
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
