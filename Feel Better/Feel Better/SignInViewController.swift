//
//  SignInViewController.swift
//  Feel Better
//
//  Created by Kevin Tong on 2019/10/13.
//  Copyright © 2019 Feel Better. All rights reserved.
//

import UIKit

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
    
    }
    
    @IBAction func selectSignIn(_ sender: Any) {
        
        hasAccount = true
        
        confirmPassword.isHidden = true
        passwordField.isHidden = true
        
        nameField.placeholder = "Email"
        emailField.placeholder = "Password"
    }
    
    @IBAction func selectSignUp(_ sender: Any) {
        
        hasAccount = false
        
        confirmPassword.isHidden = false
        passwordField.isHidden = false
        
        nameField.placeholder = "First Name Last Name"
        emailField.placeholder = "Email"
    }
    
    
    @IBAction func sign(_ sender: Any){
        
        if hasAccount{
            
        }else{
            
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
