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



//Segue Identifier
struct Identifier {
    static let TO_LOGIN = "toLogin"
    static let TO_CREATE_ACCOUNT = "toCreateAccount"
    static let UNWIND = "unwindToChannell"
}
//User Defaults
let loggedInKey = "loggedIn"
let tokenKey = "token"
let email = "userEmail"

//Header
let header = [
    "Content-Type":"application/json; charset=utf-8"
]
