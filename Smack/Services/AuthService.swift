//
//  AuthService.swift
//  Smack
//
//  Created by Milad Nourizade on 9/13/18.
//  Copyright © 2018 Milad Nourizade. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

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
        let lowerCasedEmail = email.lowercased()
        
        let header = [
            "Content-Type":"application/json; charset=utf-8"
        ]
        let body:[String:Any] = [
            "email":lowerCasedEmail,
            "password":password
        ]
        
        Alamofire.request(registerUrl, method:.post, parameters:body, encoding:JSONEncoding.default, headers: header).responseString { (response) in
            if response.result.error == nil {
                completion(true)
            }else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    func loginUser(email:String, password:String,completion:@escaping completionHandeler) {
        let lowerCasedEmail = email.lowercased()
        
        let body:[String:Any] = [
            "email":lowerCasedEmail,
            "password":password
        ]
        Alamofire.request(loginUrl, method: .post, parameters: body, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
            if response.result.error == nil {
                
                //Using SwiftyJson
                guard let data = response.data else {return}
                
                do{
                    let json = try JSON(data: data)
                    self.userEmail = json["user"].stringValue
                    self.authToken = json["token"].stringValue
                    completion(true)
                    self.isLoggedIn = true
                }
                catch {
                    print(error)
                }
            }else {
                completion(false)
                self.isLoggedIn = false
            }
        }
    }
    
    
}
