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
    
    func logedout() {
        MessageService.instance.channels = []
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
}
