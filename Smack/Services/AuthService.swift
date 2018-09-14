//
//  AuthService.swift
//  Smack
//
//  Created by Milad Nourizade on 9/13/18.
//  Copyright © 2018 Milad Nourizade. All rights reserved.
//

import Foundation
import Alamofire

class AuthService {
    
    static let instance = AuthService()
    
    let Defaults = UserDefaults.standard
    
    
    var isLoggedIn:Bool {
        get {
            return Defaults.bool(forKey: loggedInKey)
        }
        set {
            Defaults.set(newValue, forKey: loggedInKey)
            
        }
    }
    
    var userEmail:String {
        get {
            return Defaults.value(forKey: email) as! String
        }
        set {
            Defaults.setValue(newValue, forKey: email)
        }
    }
    
    var authToken:String {
        get {
            return Defaults.value(forKey:tokenKey) as! String
        }
        set {
            Defaults.setValue(newValue, forKey:tokenKey)
        }
    }
    
    func registerUser(email:String, password:String, completion:@escaping completionHandeler) {
        let lowerCasedEmail = userEmail.lowercased()
        
        let header = [
            "Content-Type":"application/json; charset=utf-8"
        ]
        let body:[String:Any] = [
            "email":lowerCasedEmail,
            "password":password
        ]
        
        Alamofire.request(urlRegister, method:.post, parameters:body, encoding:JSONEncoding.default, headers: header).responseString { (response) in
            if response.result.error == nil {
                completion(true)
            }else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
        
        
        
    }
}
