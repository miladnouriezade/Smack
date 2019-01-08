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
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self

        self.revealViewController().rearViewRevealWidth = self.view.frame.size.width - 60
        
        //Notifications Observers
        NotificationCenter.default.addObserver(self, selector: #selector(userDataDidChange(_:)), name: notifUserDataChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(channelsLoaded(_:)), name: notifChannelsLoaded, object: nil)
        
        SocketService.instance.getChannel { (success) in
            if success {
                self.tableView.reloadData()
            }
        }
        
        SocketService.instance.getChatMessages { (newMessage) in
            if newMessage.channelId != MessageService.instance.selectedChannel?.id {
                MessageService.instance.unreadChannels.append(newMessage.channelId)
                self.tableView.reloadData()
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        setupUserInfo()
    }
    
    @IBAction func addChannelPressed(_ sender: Any) {
        // showing addChannel modally
        if AuthService.instance.isLoggedIn {
            
            let addChannelVC = AddChannelVC()
            addChannelVC.modalPresentationStyle = .custom
            present(addChannelVC,animated: true, completion: nil)
        }else {
            showAlert()
        }
    }
    @objc func userDataDidChange(_ notif:Notification) {
        setupUserInfo()
    }
    @objc func channelsLoaded(_ notif : Notification) {
        tableView.reloadData()
    }
    @IBAction func loginBtnPressed(_ sender: UIButton) {
        if AuthService.instance.isLoggedIn {
            //showing profile page modally
            
            let profile = ProfileVC()
            profile.modalPresentationStyle = .custom
            present(profile, animated: true, completion: nil)
            
        } else {
            performSegue(withIdentifier:Identifier.TO_LOGIN , sender: nil)
        }
    }
    
    func setupUserInfo() {
        
        let user = UserDataService.instance
        
        if AuthService.instance.isLoggedIn {
            loginBtn.setTitle(user.name, for: .normal)
            userImage.image = UIImage(named: user.avatarName)
            userImage.backgroundColor = user.returnAvatarColor(components: user.avatarColor)
            
        }else {
            loginBtn.setTitle("Login", for: .normal)
            userImage.image = UIImage(named: "menuProfileIcon")
            userImage.backgroundColor = UIColor.clear
            
            tableView.reloadData()
        }
    }
    
    func showAlert() {
        
        let alertController = UIAlertController(title: "Whoops!!!", message: "you are not loged in", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        
        alertController.addAction(ok)
        self.present(alertController, animated: true, completion: nil)
    }
    @IBAction func prepareForUnwind(segue:UIStoryboardSegue) { }
    
   

}
extension ChannelVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let channel = MessageService.instance.channels[indexPath.row]
        MessageService.instance.selectedChannel = channel
        
        if MessageService.instance.unreadChannels.count > 0 {
            MessageService.instance.unreadChannels = MessageService.init().unreadChannels.filter{$0 != channel.id}
        }
        let index = IndexPath(row: indexPath.row, section: 0)
        tableView.reloadRows(at:[index], with:.none)
        tableView.selectRow(at: index, animated:false, scrollPosition: .none)
        
        NotificationCenter.default.post(name: notifChannelSelected, object: nil)
        self.revealViewController().revealToggle(animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension ChannelVC : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ChannelCell", for: indexPath) as? ChannelCell {
            let channel = MessageService.instance.channels[indexPath.row]
            cell.configureCell(channel: channel)
            
            return cell
        } else {
            return UITableViewCell()
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessageService.instance.channels.count
    }
    
    
}
