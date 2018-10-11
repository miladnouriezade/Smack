//
//  UserDataService.swift
//  Smack
//
//  Created by Milad Nourizade on 10/4/18.
//  Copyright © 2018 Milad Nourizade. All rights reserved.
//

import Foundation

class UserDataService {
    static let instance = UserDataService()
    
    public private(set) var id = ""
    public private(set) var name = ""
    public private(set) var email = ""
    public private(set) var avatarName = ""
    public private(set) var avatarColor = ""

    func setData(id:String, name:String, email:String, color:String,avatarName:String) {
        self.id = id
        self.name = name
        self.email = email
        self.avatarColor = color
        self.avatarName = avatarName
    }
    
    func setAvatarName(_ name:String) {
        self.avatarName = name
    }


}



