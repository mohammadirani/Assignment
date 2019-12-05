//
//  GetUserIdMessage.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on February 11, 2019

import Foundation


class GetUserIdMessage : NSObject, NSCoding{

    var chatId : String!
    var fromId : String!
    var toId : String!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        chatId = dictionary["chat_id"] as? String
        fromId = dictionary["from_id"] as? String
        toId = dictionary["to_id"] as? String
    }
    
    override init() {
        
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if chatId != nil{
            dictionary["chat_id"] = chatId
        }
        if fromId != nil{
            dictionary["from_id"] = fromId
        }
        if toId != nil{
            dictionary["to_id"] = toId
        }
        return dictionary
    }

    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        chatId = aDecoder.decodeObject(forKey: "chat_id") as? String
        fromId = aDecoder.decodeObject(forKey: "from_id") as? String
        toId = aDecoder.decodeObject(forKey: "to_id") as? String
    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if chatId != nil{
            aCoder.encode(chatId, forKey: "chat_id")
        }
        if fromId != nil{
            aCoder.encode(fromId, forKey: "from_id")
        }
        if toId != nil{
            aCoder.encode(toId, forKey: "to_id")
        }
    }
}
