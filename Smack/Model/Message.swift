//
//  Message.swift
//  Smack
//
//  Created by Milad Nourizade on 1/4/19.
//  Copyright © 2019 Milad Nourizade. All rights reserved.
//

import Foundation

struct Message {
    public private (set) var message : String!
    public private (set) var id : String!
    public private (set) var channelId : String!
    public private (set) var userName : String!
    public private (set) var userAvatar : String!
    public private (set) var userAvatarColor : String!
    public private (set) var timeStamp : String!
    
    init(message : String, id : String, channelId : String, userName : String, userAvatar : String, userAvatarColor : String, timeStamp : String) {
        self.message = message
        self.id = id
        self.channelId = channelId
        self.userName = userName
        self.userAvatar = userAvatar
        self.userAvatarColor = userAvatarColor
        self.timeStamp = timeStamp
    }
}
