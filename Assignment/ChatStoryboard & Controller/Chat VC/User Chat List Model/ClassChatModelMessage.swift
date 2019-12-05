//
//  ClassChatModelMessage.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on February 8, 2019

import Foundation


class ClassChatModelMessage : NSObject, NSCoding{

    var accountHandle : String!
    var chatId : String!
    var createdAt : Int!
    var email : String!
    var firstName : String!
    var image : String!
    var lastMessageTime : Int!
    var lastName : String!
    var message : String!
    var userId : String!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        accountHandle = dictionary["account_handle"] as? String
        chatId = dictionary["chat_id"] as? String
        createdAt = dictionary["created_at"] as? Int
        email = dictionary["email"] as? String
        firstName = dictionary["first_name"] as? String
        image = dictionary["image"] as? String
        lastMessageTime = dictionary["last_message_time"] as? Int
        lastName = dictionary["last_name"] as? String
        message = dictionary["message"] as? String
        userId = dictionary["user_id"] as? String

    }
    
    override init() {
        
    }


    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if accountHandle != nil{
            dictionary["account_handle"] = accountHandle
        }
        if chatId != nil{
            dictionary["chat_id"] = chatId
        }
        if createdAt != nil{
            dictionary["created_at"] = createdAt
        }
        if email != nil{
            dictionary["email"] = email
        }
        if firstName != nil{
            dictionary["first_name"] = firstName
        }
        if image != nil{
            dictionary["image"] = image
        }
        if lastMessageTime != nil{
            dictionary["last_message_time"] = lastMessageTime
        }
        if lastName != nil{
            dictionary["last_name"] = lastName
        }
        if message != nil{
            dictionary["message"] = message
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
        accountHandle = aDecoder.decodeObject(forKey: "account_handle") as? String
        chatId = aDecoder.decodeObject(forKey: "chat_id") as? String
        createdAt = aDecoder.decodeObject(forKey: "created_at") as? Int
        email = aDecoder.decodeObject(forKey: "email") as? String
        firstName = aDecoder.decodeObject(forKey: "first_name") as? String
        image = aDecoder.decodeObject(forKey: "image") as? String
        lastMessageTime = aDecoder.decodeObject(forKey: "last_message_time") as? Int
        lastName = aDecoder.decodeObject(forKey: "last_name") as? String
        message = aDecoder.decodeObject(forKey: "message") as? String
        userId = aDecoder.decodeObject(forKey: "user_id") as? String
    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if accountHandle != nil{
            aCoder.encode(accountHandle, forKey: "account_handle")
        }
        if chatId != nil{
            aCoder.encode(chatId, forKey: "chat_id")
        }
        if createdAt != nil{
            aCoder.encode(createdAt, forKey: "created_at")
        }
        if email != nil{
            aCoder.encode(email, forKey: "email")
        }
        if firstName != nil{
            aCoder.encode(firstName, forKey: "first_name")
        }
        if image != nil{
            aCoder.encode(image, forKey: "image")
        }
        if lastMessageTime != nil{
            aCoder.encode(lastMessageTime, forKey: "last_message_time")
        }
        if lastName != nil{
            aCoder.encode(lastName, forKey: "last_name")
        }
        if message != nil{
            aCoder.encode(message, forKey: "message")
        }
        if userId != nil{
            aCoder.encode(userId, forKey: "user_id")
        }
    }
}
