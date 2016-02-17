//
//  LoginViewController.swift
//  ContactsList
//
//  Created by luis cabarique on 2/16/16.
//  Copyright © 2016 cabarique inc. All rights reserved.
//

import UIKit
import Material

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var usernameTextField: TextField!
    @IBOutlet weak var passwordTextField: TextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigator.navigationBarHidden = true
        // Do any additional setup after loading the view.
        
        usernameTextField.titleLabel = UILabel()
        usernameTextField.titleLabelColor = MaterialColor.white
        usernameTextField.clearButtonMode = .WhileEditing
        usernameTextField.backgroundColor = UIColor.clearColor()
        usernameTextField.textColor = MaterialColor.white
        usernameTextField.borderColor = MaterialColor.white
        usernameTextField.titleLabelActiveColor = MaterialColor.white
        
        passwordTextField.backgroundColor = UIColor.clearColor()
        passwordTextField.borderColor = MaterialColor.white
        passwordTextField.textColor = MaterialColor.grey.lighten5
        
        usernameTextField.delegate = self
        passwordTextField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func login(sender: AnyObject) {
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        if usernameTextField.text == "Luis" && passwordTextField.text == "test"{
            navigator.pushViewController(SideNavigationViewController(mainViewController: ContactsListViewController(), sideViewController: SideViewController()), animated: true)
            usernameTextField.text = ""
            passwordTextField.text = ""
        }else{
            let error = UIAlertController(title: "Authentication error", message: "Username or password incorrect, please try again!", preferredStyle: UIAlertControllerStyle.Alert)
            error.addAction(UIAlertAction(title: "ok", style: .Default, handler: nil))
            navigator.presentViewController(error, animated: true, completion: nil)
        }
        
        
        
    }

    
}
