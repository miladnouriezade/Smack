//
//  Channel.swift
//  Smack
//
//  Created by Milad Nourizade on 12/29/18.
//  Copyright © 2018 Milad Nourizade. All rights reserved.
//

import Foundation

struct Channel {
    public private (set) var id : String!
    public private (set) var description : String!
    public private (set) var title : String!
    
    init(id:String, description : String, title : String) {
        self.id = id
        self.description = description
        self.title = title
    }
    
}
