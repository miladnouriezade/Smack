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
    @IBOutlet weak var messageTxtBox: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.bindToKeyboard()
        
        //TableView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tap)
        
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
        SocketService.instance.getChatMessages { (success) in
            if success {
                self.tableView.reloadData()
                if MessageService.instance.messages.count > 0 {
                    let endIndex = IndexPath(row: MessageService.instance.messages.count - 1, section: 0)
                    self.tableView.scrollToRow(at: endIndex, at: .bottom, animated: false)
                }
            }
        }
    }
    
    @objc func userDataDidChange(_ notif: Notification) {
        if AuthService.instance.isLoggedIn {
            onLoginGetMessages()
        } else {
            currentlyChannel.text = "Please Log In"
            self.tableView.reloadData()
        }
    }
    
    
    @objc func channelSelected(_ notif : Notification) {
        updateCurrentlyChannel()
    }
    
    @objc func handleTap( ) {
        view.endEditing(true)
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
            if success {
                self.tableView.reloadData()
            }
        }
    }
    @IBAction func sendMessagePressed(_ sender: Any) {
        if AuthService.instance.isLoggedIn {
            guard let message = messageTxtBox.text , messageTxtBox.text != "" else { return }
            guard let channelId = MessageService.instance.selectedChannel?.id else { return }
            
            SocketService.instance.addMessage(messageBody: message, userId:UserDataService.instance.id, channelId: channelId) { (success) in
                if success {
                    self.messageTxtBox.text = ""
//                    self.messageTxtBox.resignFirstResponder()
                }
                
            }
        }
    }
    
}

extension ChatVC : UITableViewDelegate {
    
}
extension ChatVC : UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as? MessageCell {
            let message = MessageService.instance.messages[indexPath.row]
            cell.configureCell(message: message)
            
            return cell
        } else {
            return UITableViewCell()
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessageService.instance.messages.count
    }
    
}
