//
//  ProfileVC.swift
//  Smack
//
//  Created by Milad Nourizade on 12/7/18.
//  Copyright © 2018 Milad Nourizade. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController {
    //Outlets
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var backgroundImage: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
    }
    
    @IBAction func logoutPressed(_ sender: Any) {
        UserDataService.instance.logout()
        NotificationCenter.default.post(name: notifUserDataChanged, object: nil)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func closeBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func setupView() {
        let view = self.view.viewWithTag(10)
        view?.layer.cornerRadius = 10.0
        
        let instance = UserDataService.instance
        
        userImage.image = UIImage(named: instance.avatarName)
        userImage.backgroundColor = instance.returnAvatarColor(components: instance.avatarColor)
        username.text = instance.name
        userEmail.text = instance.email
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ProfileVC.closeTap(_:)))
        backgroundImage.addGestureRecognizer(tapGesture)
    }
    
    
    @objc func closeTap(_ recognizer:UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
    
    
}
