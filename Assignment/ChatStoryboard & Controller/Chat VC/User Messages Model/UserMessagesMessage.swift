//
//  UserMessagesMessage.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on February 8, 2019

import Foundation


class UserMessagesMessage: NSObject {

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

}
