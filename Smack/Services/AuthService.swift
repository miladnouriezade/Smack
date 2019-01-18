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
    
    func registerUser(email:String, password:String, completion:@escaping(_ statusCode : Int)->Void) {
        let lowerCasedEmail = email.lowercased()
        
        let header = [
            "Content-Type":"application/json; charset=utf-8"
        ]
        let body:[String:Any] = [
            "email":lowerCasedEmail,
            "password":password
        ]
        
        Alamofire.request(registerUrl, method:.post, parameters:body, encoding:JSONEncoding.default, headers: header).responseString { (response) in
            
            guard let statusCode = response.response?.statusCode else { return }
            
            switch statusCode {
            case 300:
                print("User already exists")
                completion(300)
            case 409:
                print("An error occured")
                completion(409)
            case 200:
                print("Successfully created new account")
                completion(200)
            default:
                completion(500)
            }
        }
    }
    
    func loginUser(email:String, password:String,completion:@escaping (_ statusCode : Int)->Void ) {
        let lowerCasedEmail = email.lowercased()
        
        let body:[String:Any] = [
            "email":lowerCasedEmail,
            "password":password
        ]
        Alamofire.request(loginUrl, method: .post, parameters: body, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
            
            guard let statusCode = response.response?.statusCode else { return }
            
            switch statusCode {
            case 200:
                
                guard let data = response.data else {return}
                
                do{
                    let json = try JSON(data: data)
                    self.userEmail = json["user"].stringValue
                    self.authToken = json["token"].stringValue
            
                    self.isLoggedIn = true
                    completion(200)
                }
                catch {
                    print(error)
                }
                
            case 401:
                completion(401)
                self.isLoggedIn = false
                print("An error occured")
                
            case 409:
                completion(409)
                self.isLoggedIn = false
                print("Email or password invalid, please check your credentials")
                
            default:
                completion(500)
                self.isLoggedIn = false
                
            }
        }
    }
    
    func addUser(email:String, name:String, avatarColor:String, avatarName:String, completion:@escaping completionHandeler) {
     
        let lowerCasedEmail = email.lowercased()
        
        let body:[String:Any] = [
            "name":name,
            "email":lowerCasedEmail,
            "avatarName":avatarName,
            "avatarColor":avatarColor
        ]
        
        
        Alamofire.request(addUserUrl, method: .post, parameters: body, encoding: JSONEncoding.default, headers:bearerHeader).responseJSON { (response) in
            if response.result.error == nil {
                guard let data = response.data else{return}
                self.setUserInfo(data: data)
                
                completion(true)
                
            } else {
                completion(false)
            }
        }
    }
    
    func findUserByEmail(completion:@escaping completionHandeler) {
        
        Alamofire.request("\(userByEmailUrl)\(userEmail)", method: .get, parameters: nil, encoding:JSONEncoding.default, headers: bearerHeader).responseJSON{ (response) in
            if response.result.error == nil {
                guard let data = response.data else{return}
                self.setUserInfo(data: data)
                
                completion(true)
                
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    func setUserInfo(data : Data) {
        do {
            let json = try JSON(data:data)
            let id = json["_id"].stringValue
            let name = json["name"].stringValue
            let email = json["email"].stringValue
            let avatarName = json["avatarName"].stringValue
            let avatarColor = json["avatarColor"].stringValue
            
            UserDataService.instance.setData(id: id, name: name, email: email, color: avatarColor, avatarName: avatarName)
        } catch {
            print(error)
        }
    }
}
