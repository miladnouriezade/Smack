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
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    //Variables
    var avatarName = "profileDefault"
    var avatarColor = "[0.5 ,0.5, 0.5, 1]"
    var bacgroundColor:UIColor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        createAccountBtn.layer.cornerRadius = 5

    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if UserDataService.instance.avatarName != "" {
        let avatarName = UserDataService.instance.avatarName
        userImage.image = UIImage(named:avatarName)
            setRandomColor(image: userImage)
            self.avatarName = avatarName
            
        }
    }
    
    func setRandomColor(image:UIImageView) {
        let r = CGFloat(arc4random_uniform(255)) / 255
        let g = CGFloat(arc4random_uniform(255)) / 255
        let b = CGFloat(arc4random_uniform(255)) / 255
        bacgroundColor = UIColor(red: r, green: g, blue: b, alpha: 1)
        avatarColor = "[\(r), \(g), \(b), 1]"
        
        image.backgroundColor = bacgroundColor
    }
    
    @IBAction func closeBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: Identifier.UNWIND, sender: nil)
    }
    
    @IBAction func createAccount(_ sender: Any) {
        guard let name = userNameTxt.text, userNameTxt.text != "" else { return}
        guard let email = emailTxt.text, emailTxt.text != "" else { return}
        guard let password = passwordTxt.text, passwordTxt.text != "" else {return}
        createAccountBtn.setTitle("", for: .normal)
        spinner.isHidden = false
        spinner.startAnimating()
        
        AuthService.instance.registerUser(email: email, password: password) { (statusCode) in
            switch statusCode {

            case 200:
                AuthService.instance.loginUser(email: email, password: password, completion: { (statusCode) in
                    switch statusCode {
                    case 200:
                        AuthService.instance.addUser(email: email, name:name, avatarColor: self.avatarColor, avatarName: self.avatarName, completion: { (success) in
                            if success {
                                self.spinner.isHidden = true
                                self.spinner.stopAnimating()
                                self.performSegue(withIdentifier: Identifier.UNWIND, sender: nil)
                                
                                NotificationCenter.default.post(name:notifUserDataChanged , object: self)
                            }
                        })
                    default:
                        self.showAlert(statusCode: 409)
                        
                    }
//                    if success {
//                        AuthService.instance.addUser(email: email, name:name, avatarColor: self.avatarColor, avatarName: self.avatarName, completion: { (success) in
//                            if success {
//                                self.spinner.isHidden = true
//                                self.spinner.stopAnimating()
//                                self.performSegue(withIdentifier: Identifier.UNWIND, sender: nil)
//
//                                NotificationCenter.default.post(name:notifUserDataChanged , object: self)
//                            }
//                        })
//                    }
                })
            case 300:
                self.showAlert(statusCode: 300)
            case 409:
                self.showAlert(statusCode: 409)
            default:
                self.showAlert(statusCode: 500)
            }
        }
    }
    
    func setupView() {
        spinner.isHidden = true
        
        userNameTxt.attributedPlaceholder = NSAttributedString(string: "username", attributes: [NSAttributedStringKey.foregroundColor:placeholderColor])
        emailTxt.attributedPlaceholder = NSAttributedString(string: "email", attributes: [NSAttributedStringKey.foregroundColor:placeholderColor])
        passwordTxt.attributedPlaceholder = NSAttributedString(string: "password", attributes: [NSAttributedStringKey.foregroundColor:placeholderColor])
        
        let tap = UITapGestureRecognizer(target: self, action: #selector (tapHandler))
        view.addGestureRecognizer(tap)
        
    }
    
    func showAlert(statusCode : Int) {
        var message = ""
        
        switch statusCode {
        case 300:
            message = "User already registered"
        default:
            message = "An error occured"
        }
        
        let alertController = UIAlertController(title: "Whoops!!!", message:message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        
        alertController.addAction(ok)
        self.present(alertController, animated: true, completion: nil)
        
        self.spinner.stopAnimating()
        self.spinner.isHidden = true
        self.createAccountBtn.setTitle("Create my Account", for: .normal)
    }

    
    @objc func tapHandler () {
        view.endEditing(true)
    }
    
    
    @IBAction func chooseAvatar(_ sender: Any) {
        performSegue(withIdentifier:Identifier.TO_AVATARPICKER, sender: nil)
    }
    
}
