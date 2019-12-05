//
//  UserMessagesNewMessage.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on February 21, 2019

import Foundation


class UserMessagesNewMessage : NSObject, NSCoding{

    var isBlocked : Int!
    var messagesNew : [UserMessagesNewMessagesNew]!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        isBlocked = dictionary["is_blocked"] as? Int
        messagesNew = [UserMessagesNewMessagesNew]()
        if let messagesNewArray = dictionary["messages"] as? [[String:Any]]{
            for dic in messagesNewArray{
                let value = UserMessagesNewMessagesNew(fromDictionary: dic)
                messagesNew.append(value)
            }
        }
    }
    
    override init() {
        
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if isBlocked != nil{
            dictionary["is_blocked"] = isBlocked
        }
        if messagesNew != nil{
            var dictionaryElements = [[String:Any]]()
            for messagesNewElement in messagesNew {
                dictionaryElements.append(messagesNewElement.toDictionary())
            }
            dictionary["messages"] = dictionaryElements
        }
        return dictionary
    }

    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        isBlocked = aDecoder.decodeObject(forKey: "is_blocked") as? Int
        messagesNew = aDecoder.decodeObject(forKey: "messages") as? [UserMessagesNewMessagesNew]
    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if isBlocked != nil{
            aCoder.encode(isBlocked, forKey: "is_blocked")
        }
        if messagesNew != nil{
            aCoder.encode(messagesNew, forKey: "messages")
        }
    }
}
