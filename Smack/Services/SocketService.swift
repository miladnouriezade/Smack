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
    
    

}
