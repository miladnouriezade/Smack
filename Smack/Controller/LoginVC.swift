//
//  LoginVC.swift
//  Smack
//
//  Created by Milad Nourizade on 9/10/18.
//  Copyright © 2018 Milad Nourizade. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    
    //Outlets
    @IBOutlet weak var LoginBtn: UIButton!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()

    }
    
    @IBAction func loginPressed(_ sender: UIButton) {
        spinner.isHidden = false
        LoginBtn.setTitle("", for: .normal)
        spinner.startAnimating()
        
        guard let emailValue = email.text, email.text != ""  else { return}
        guard let passwordValue = password.text, password.text != ""  else { return}
        
        AuthService.instance.loginUser(email: emailValue, password: passwordValue) { (statusCode) in
            switch statusCode {
            case 200:
                AuthService.instance.findUserByEmail(completion: { (success) in
                    if success {
                        NotificationCenter.default.post(name: notifUserDataChanged, object: nil)
                        self.spinner.isHidden = true
                        self.spinner.stopAnimating()
                        self.dismiss(animated: true, completion: nil)
                    }
                })
                
            case 401:
                self.showAlert(statusCode: 401)
            default:
                self.showAlert(statusCode: 409)
            }
        }
    }
    
    @IBAction func CloseBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func createAccount(_ sender: UIButton) {
        performSegue(withIdentifier: Identifier.TO_CREATE_ACCOUNT, sender: nil)
    }
    func setupView() {
        LoginBtn.layer.cornerRadius = 5
        
        spinner.isHidden = true
        
        email.attributedPlaceholder = NSAttributedString(string: "email", attributes: [NSAttributedStringKey.foregroundColor:placeholderColor])
        password.attributedPlaceholder = NSAttributedString(string: "password", attributes: [NSAttributedStringKey.foregroundColor:placeholderColor])
    }
    
    func showAlert(statusCode : Int) {
        var message = ""
        
        switch statusCode {
        case 300:
            message = "User already registered"
        case 401:
            message = "Email or password invalid, please check your credentials"
        default:
            message = "An error occured"
        }
        
        let alertController = UIAlertController(title: "Whoops!!!", message:message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        
        alertController.addAction(ok)
        self.present(alertController, animated: true, completion: nil)
        
        self.spinner.stopAnimating()
        self.spinner.isHidden = true
        self.LoginBtn.setTitle("login", for: .normal)
    }
    
}
