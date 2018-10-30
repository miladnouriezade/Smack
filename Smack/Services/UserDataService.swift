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
    
    func returnAvatarColor(components:String) -> UIColor {
        let scanner = Scanner(string: components)
        let skippedChars = CharacterSet(charactersIn: "[], ")
        let comma = CharacterSet(charactersIn: ",")
        scanner.charactersToBeSkipped = skippedChars
        
        var r, g, b : NSString?
        
        scanner.scanUpToCharacters(from: comma, into: &r)
        scanner.scanUpToCharacters(from: comma, into: &g)
        scanner.scanUpToCharacters(from: comma, into: &b)
        
        let defaultColor = UIColor.lightGray
        
        guard let rValue = r else { return defaultColor}
        guard let gValue = g else { return defaultColor}
        guard let bValue = b else { return defaultColor}
        
        
        let rFloat = CGFloat(rValue.doubleValue)
        let gFloat = CGFloat(gValue.doubleValue)
        let bFloat = CGFloat(bValue.doubleValue)
        
    
        let backgroundColor = UIColor(red: rFloat, green: gFloat, blue: bFloat, alpha:1)
        
        return backgroundColor
        
    }


}



