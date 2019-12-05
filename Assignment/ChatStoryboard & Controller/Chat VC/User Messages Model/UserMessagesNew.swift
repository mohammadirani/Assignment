//
//  UserMessagesNew.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on February 21, 2019

import Foundation


class UserMessagesNew : NSObject, NSCoding{

    var message : [UserMessagesNewMessage]!
    var statusCode : Int!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        statusCode = dictionary["statusCode"] as? Int
        message = [UserMessagesNewMessage]()
        if let messageArray = dictionary["message"] as? [String:Any]{
            //for dic in messageArray{
                let value = UserMessagesNewMessage(fromDictionary: messageArray)
               message.append(value)
            print(value)
//            }
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
        if statusCode != nil{
            dictionary["statusCode"] = statusCode
        }
        if message != nil{
            var dictionaryElements = [[String:Any]]()
            for messageElement in message {
                dictionaryElements.append(messageElement.toDictionary())
            }
            dictionary["message"] = dictionaryElements
        }
        return dictionary
    }

    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        message = aDecoder.decodeObject(forKey: "message") as? [UserMessagesNewMessage]
        statusCode = aDecoder.decodeObject(forKey: "statusCode") as? Int
    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if message != nil{
            aCoder.encode(message, forKey: "message")
        }
        if statusCode != nil{
            aCoder.encode(statusCode, forKey: "statusCode")
        }
    }
}
