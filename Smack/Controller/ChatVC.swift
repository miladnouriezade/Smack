//
//  ChatVC.swift
//  Smack
//
//  Created by Milad Nourizade on 8/25/18.
//  Copyright © 2018 Milad Nourizade. All rights reserved.
//

import UIKit

class ChatVC: UIViewController {
    
    //Outlets
    @IBOutlet weak var menuButton:UIButton!
    @IBOutlet weak var currentlyChannel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuButton.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
        //Notification Observers
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.channelSelected(_:)), name: notifChannelSelected, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(userDataDidChange(_:)), name: notifUserDataChanged, object: nil)
        
        // check if user already loged in
        
        if AuthService.instance.isLoggedIn {
            AuthService.instance.findUserByEmail { (success) in
                NotificationCenter.default.post(name: notifUserDataChanged, object: nil)
                }
            }
        }
    
    @objc func userDataDidChange(_ notif: Notification) {
        if AuthService.instance.isLoggedIn {
            onLoginGetMessages()
        } else {
            currentlyChannel.text = "Please Log In"
        }
    }
    
    
    @objc func channelSelected(_ notif : Notification) {
        updateCurrentlyChannel()
    }
    func updateCurrentlyChannel() {
        let channelTitle = MessageService.instance.selectedChannel?.title ?? ""
        currentlyChannel.text = "#\(channelTitle)"
        getMessages()
    }
    
    
    func onLoginGetMessages() {
        MessageService.instance.findChannels { (success) in
            if success {
                if MessageService.instance.channels.count > 0 {
                    MessageService.instance.selectedChannel = MessageService.instance.channels[0]
                    
                    self.updateCurrentlyChannel()
                } else {
                    self.currentlyChannel.text = "No channel yet!"
                }
            }
        }
    }
    
    func getMessages() {
        guard let channelId = MessageService.instance.selectedChannel?.id else { return }
        
        MessageService.instance.getMessages(for: channelId) { (success) in
            
        }
    }


}
