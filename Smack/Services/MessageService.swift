//
//  MessageService.swift
//  Smack
//
//  Created by Milad Nourizade on 12/29/18.
//  Copyright © 2018 Milad Nourizade. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class MessageService {
    
    static let instance = MessageService()
    
    var channels = [Channel]()
    var messages = [Message]()
    var unreadChannels = [String]()
    var selectedChannel : Channel?
    
    func clearChannels() {
        self.channels.removeAll()
    }
    
    func clearMessages() {
        self.messages.removeAll()
    }
    
    func findChannels(compelition : @escaping completionHandeler) {
        Alamofire.request(findChannelsUrl, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: bearerHeader).responseJSON { (response) in
            
            if response.result.error == nil {
                
                guard let data = response.data else { return }
                do{
                    if let json = try JSON(data: data).array {
                        for item in json {
                            
                            let id = item["_id"].stringValue
                            let description = item["description"].stringValue
                            let name = item["name"].stringValue
                            
                            let channel = Channel(id: id, description: description, title: name)
                            
                            self.channels.append(channel)
                        }
                        NotificationCenter.default.post(name:notifChannelsLoaded, object: nil)
                        compelition(true)
                    }
                }catch {
                    print(error)
                }
            } else {
                compelition(false)
                debugPrint(response.result.error as Any)
            }
        }
        
    }
    
    func getMessages(for channelId : String, completion : @escaping completionHandeler) {
        
        Alamofire.request("\(getMessagesUrl)\(channelId)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: bearerHeader).responseJSON { (response) in
            if response.result.error == nil {
                self.clearMessages()
                guard let data = response.data else { return }
                
                do {
                    if let json = try JSON(data: data).array {
                        for item in json {
                            
                            let id = item["_id"].stringValue
                            let messageBody = item["messageBody"].stringValue
                            let channelId = item["channelId"].stringValue
                            let userName = item["userName"].stringValue
                            let userAvatar = item["userAvatar"].stringValue
                            let userAvatarColor = item["userAvatarColor"].stringValue
                            let timeStamp = item["timeStamp"].stringValue
                            
                            let message = Message(message: messageBody, id: id, channelId: channelId, userName: userName, userAvatar: userAvatar, userAvatarColor: userAvatarColor, timeStamp: timeStamp)
                            
                            self.messages.append(message)
                        }
                        completion(true)
                        
                    }
                    
                } catch {
                    print(error)
                }
               
                
            } else {
                debugPrint(response.result.error as Any)
                completion(false)
            }
        }
        
    }
    

    
    
    
}
