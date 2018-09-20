//
//  CreateAccountVC.swift
//  Smack
//
//  Created by Milad Nourizade on 9/11/18.
//  Copyright © 2018 Milad Nourizade. All rights reserved.
//

import UIKit

class CreateAccountVC: UIViewController {
    //Outlets
    @IBOutlet weak  var createAccountBtn:UIButton!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userNameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createAccountBtn.layer.cornerRadius = 5

    }
    @IBAction func closeBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: Identifier.UNWIND, sender: nil)
    }
    
    @IBAction func createAccount(_ sender: Any) {
        guard let email = emailTxt.text, emailTxt.text != "" else { return}
        guard let password = passwordTxt.text, passwordTxt.text != "" else {return}
        
        AuthService.instance.registerUser(email: email, password: password) { (success) in
            if success {
                AuthService.instance.loginUser(email: email, password: password, completion: { (success) in
                    if success {
                        print("successfuly logged in",AuthService.instance.authToken)
                    }
                })
            }
        }
        
    }
    
    @IBAction func chooseAvatar(_ sender: Any) {
    }
    
}
