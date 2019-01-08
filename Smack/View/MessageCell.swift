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
        
        guard var isoDate = message.timeStamp else {return}
        let end = isoDate.index(isoDate.endIndex, offsetBy: -5)
        isoDate = isoDate.substring(to: end)
        
        let isoFormatter = ISO8601DateFormatter()
        let messageDate = isoFormatter.date(from: isoDate.appending("Z"))
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d , h:mm a"
        
        if let finalDate = messageDate {
            let timeStamp = dateFormatter.string(from: finalDate)
            timestampLabel.text = timeStamp
        }
    }

}
