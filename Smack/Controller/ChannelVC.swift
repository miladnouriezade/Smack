//
//  ChannelVC.swift
//  Smack
//
//  Created by Milad Nourizade on 8/25/18.
//  Copyright © 2018 Milad Nourizade. All rights reserved.
//

import UIKit

class ChannelVC: UIViewController {
    
    //Outlets
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var userImage: RoundedCorner!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.revealViewController().rearViewRevealWidth = self.view.frame.size.width - 60
        
        NotificationCenter.default.addObserver(self, selector: #selector(userDataDidChange(_:)), name: notifiUserDataChanged, object: nil)
        
        
        
    }
    
    @objc func userDataDidChange(_ notif:Notification) {
        let user = UserDataService.instance
        if AuthService.instance.isLoggedIn {
            loginBtn.setTitle(user.name, for: .normal)
            userImage.image = UIImage(named: user.avatarName)
            userImage.backgroundColor = user.returnAvatarColor(components: user.avatarColor)
            
        }else {
            loginBtn.setTitle("Login", for: .normal)
            userImage.image = UIImage(named: "menuProfileIcon")
        }
    }
    @IBAction func loginBtnPressed(_ sender: UIButton) {
        performSegue(withIdentifier:Identifier.TO_LOGIN , sender: nil)
    
    }
    @IBAction func prepareForUnwind(segue:UIStoryboardSegue) { }
    
   

}
