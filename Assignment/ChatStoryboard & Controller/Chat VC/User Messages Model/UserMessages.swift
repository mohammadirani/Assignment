//
//  UserMessages.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on February 8, 2019

import Foundation


class UserMessages : NSObject{

    var message : [UserMessagesStatus]!
    var statusCode : Int!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        statusCode = dictionary["statusCode"] as? Int
        message = [UserMessagesStatus]()
        if let messageArray = dictionary["message"] as? [[String:Any]]{
            for dic in messageArray{
                let value = UserMessagesStatus(fromDictionary: dic)
                message.append(value)
            }
        }
    }
    
    override init() {
        
    }


    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
//    func toDictionary() -> [String:Any]
//    {
//        var dictionary = [String:Any]()
//        if statusCode != nil{
//            dictionary["statusCode"] = statusCode
//        }
//        if message != nil{
//            var dictionaryElements = [[String:Any]]()
//            for messageElement in message {
//                dictionaryElements.append(messageElement.toDictionary())
//            }
//            dictionary["message"] = dictionaryElements
//        }
//        return dictionary
//    }

    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
//    @objc required init(coder aDecoder: NSCoder)
//    {
//        message = aDecoder.decodeObject(forKey: "message") as? [UserMessagesMessage]
//        statusCode = aDecoder.decodeObject(forKey: "statusCode") as? Int
//    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
//    @objc func encode(with aCoder: NSCoder)
//    {
//        if message != nil{
//            aCoder.encode(message, forKey: "message")
//        }
//        if statusCode != nil{
//            aCoder.encode(statusCode, forKey: "statusCode")
//        }
//    }
}
