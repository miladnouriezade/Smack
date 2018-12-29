//
//  Constants.swift
//  Smack
//
//  Created by Milad Nourizade on 9/10/18.
//  Copyright © 2018 Milad Nourizade. All rights reserved.
//

import Foundation

typealias completionHandeler = (_ success:Bool) -> ()

//URL
let mainUrl =  "https://slackchatt.herokuapp.com/v1/"
let registerUrl = "\(mainUrl)account/register"
let loginUrl = "\(mainUrl)account/login"
let addUserUrl = "\(mainUrl)user/add"
let userByEmailUrl = "\(mainUrl)user/byEmail/"

//Color
let placeholderColor = #colorLiteral(red: 0.3266413212, green: 0.4215201139, blue: 0.7752227187, alpha: 0.5)

//Notification Constant
let notifiUserDataChanged = Notification.Name(rawValue: "notifiUserDataChanged")



//Segue Identifier
struct Identifier {
    static let TO_LOGIN = "toLogin"
    static let TO_CREATE_ACCOUNT = "toCreateAccount"
    static let UNWIND = "unwindToChannell"
    static let TO_AVATARPICKER = "toAvatarPicker"
}
//User Defaults
let loggedInKey = "loggedIn"
let tokenKey = "token"
let email = "userEmail"

//Headers
let header = [
    "Content-Type":"application/json; charset=utf-8"
]
let bearerHeader = [
    "Authorization":"Bearer \(AuthService.instance.authToken)",
    "Content-Type":"application/json; charset=utf-8"
]
