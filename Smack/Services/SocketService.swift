//
//  SocketService.swift
//  Smack
//
//  Created by Milad Nourizade on 1/3/19.
//  Copyright © 2019 Milad Nourizade. All rights reserved.
//

import UIKit
import SocketIO

class SocketService: NSObject {
    
    static let instance = SocketService()
    
    
    override init() {
        super.init()
    }
    
    let manager = SocketManager(socketURL: URL(string:mainUrl)!, config: [.log(true), .compress])
    lazy var  socket = manager.defaultSocket
    
    
    func establishConnection() {
        socket.connect()
        
    }
    
    func closeConnection() {
        socket.disconnect()
        
    }
    
    func addChannel (channelDescription : String, channelName : String, completion : @escaping completionHandeler) {
        socket.emit("newChannel", channelName , channelDescription)
        completion(true)
    }
    
    func getChannel(completion : @escaping completionHandeler) {
        socket.on("channelCreated") { (dataArray, SocketAckEmitter) in
            
            guard let channelName = dataArray[0] as? String else { return }
            guard let channelDesc = dataArray[1] as? String else { return }
            guard let channelId   = dataArray[2] as? String else { return }
            
            let newChannel = Channel(id: channelId, description: channelDesc, title: channelName)
            
            MessageService.instance.channels.append(newChannel)
            completion(true)
            
        }
    }
    
    func addMessage(messageBody : String,userId : String, channelId : String, completion : @escaping completionHandeler) {
        let user = UserDataService.instance
        
        socket.emit("newMessage", messageBody, userId, channelId, user.name, user.avatarName, user.avatarColor)
        completion(true)
    }
    
    func getChatMessages(completion : @escaping(_ newMessage : Message)-> Void) {
        socket.on("messageCreated") { (dataArray, SocketAckEmitter) in
            
            guard let messageBody = dataArray[0] as? String else { return }
            guard let channelId = dataArray[2] as? String else { return }
            guard let username  = dataArray[3] as? String else { return }
            guard let userAvatar = dataArray[4] as? String else { return }
            guard let userAvatarColor = dataArray[5] as? String else { return }
            guard let id = dataArray[6] as? String else { return }
            guard let timeStamp = dataArray[7] as? String else { return }
            
            let newMessage = Message(message: messageBody, id: id, channelId: channelId, userName: username, userAvatar: userAvatar, userAvatarColor: userAvatarColor, timeStamp: timeStamp)
            
            completion(newMessage)
        }
    }
    
    func startTypingEvent(username : String, channelId : String) {
        socket.emit("startType", username, channelId)
    }
    
    func stopTypingEvent(username : String, channelId : String) {
        socket.emit("stopType", username, channelId)
    }
    
    func getTypingUsers(_ completionHandler : @escaping (_ typingUsers : [String : String]) -> Void) {
        
        socket.on("userTypingUpdate") { (dataArray, SocketAckEmitter) in
            guard let typingUsers = dataArray[0] as? [String : String] else { return }
            
            completionHandler(typingUsers)
        }
        
    }
    

}
