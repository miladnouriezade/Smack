//
//  MessageCell.swift
//  Smack
//
//  Created by Milad Nourizade on 1/6/19.
//  Copyright © 2019 Milad Nourizade. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {
    
    //Outlets
    @IBOutlet weak var avatarImage: RoundedCorner!
    @IBOutlet weak var usernameLable: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell(message : Message) {
        avatarImage.image = UIImage(named: message.userAvatar)
        avatarImage.backgroundColor = UserDataService.instance.returnAvatarColor(components: message.userAvatarColor)
        usernameLable.text = message.userName
        messageLabel.text = message.message
    }

}
