//
//  AMessage.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on February 21, 2019

import Foundation


class AMessage : NSObject, NSCoding{

    var chatId : String!
    var createdAt : String!
    var id : String!
    var isRead : Int!
    var message : String!
    var updatedAt : String!
    var userId : String!
    var date: Date!
    var isVisible: Bool!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        chatId = dictionary["chat_id"] as? String
        createdAt = dictionary["created_at"] as? String
        id = dictionary["id"] as? String
        isRead = dictionary["is_read"] as? Int
        message = dictionary["message"] as? String
        updatedAt = dictionary["updated_at"] as? String
        userId = dictionary["user_id"] as? String
        date = dictionary["date"] as? Date
        isVisible = dictionary["isVisible"]as? Bool
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
        if createdAt != nil{
            dictionary["created_at"] = createdAt
        }
        if id != nil{
            dictionary["id"] = id
        }
        if isRead != nil{
            dictionary["is_read"] = isRead
        }
        if message != nil{
            dictionary["message"] = message
        }
        if updatedAt != nil{
            dictionary["updated_at"] = updatedAt
        }
        if userId != nil{
            dictionary["user_id"] = userId
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
        createdAt = aDecoder.decodeObject(forKey: "created_at") as? String
        id = aDecoder.decodeObject(forKey: "id") as? String
        isRead = aDecoder.decodeObject(forKey: "is_read") as? Int
        message = aDecoder.decodeObject(forKey: "message") as? String
        updatedAt = aDecoder.decodeObject(forKey: "updated_at") as? String
        userId = aDecoder.decodeObject(forKey: "user_id") as? String
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
        if createdAt != nil{
            aCoder.encode(createdAt, forKey: "created_at")
        }
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if isRead != nil{
            aCoder.encode(isRead, forKey: "is_read")
        }
        if message != nil{
            aCoder.encode(message, forKey: "message")
        }
        if updatedAt != nil{
            aCoder.encode(updatedAt, forKey: "updated_at")
        }
        if userId != nil{
            aCoder.encode(userId, forKey: "user_id")
        }
    }
}
