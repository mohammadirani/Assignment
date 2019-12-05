//
//  UserMessagesStatus.swift
//  Postgram
//
//  Created by mohammed on 21/02/19.
//  Copyright © 2019 IOS Developer. All rights reserved.
//

import UIKit

class UserMessagesStatus
{
    var messages : [UserMessagesMessage]!
    var is_blocked : Int!
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        is_blocked = dictionary["is_blocked"] as? Int
        messages = [UserMessagesMessage]()
        if let messageArray = dictionary["messages"] as? [[String:Any]]{
            for dic in messageArray{
                let value = UserMessagesMessage(fromDictionary: dic)
                messages.append(value)
            }
        }
    }
    
    
    
}
