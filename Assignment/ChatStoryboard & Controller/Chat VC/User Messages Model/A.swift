//
//  A.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on February 21, 2019

import Foundation


class A : NSObject, NSCoding{

    var isBlocked : Int!
    var messages : [AMessage]!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        isBlocked = dictionary["is_blocked"] as? Int
        messages = [AMessage]()
        if let messagesArray = dictionary["messages"] as? [[String:Any]]{
            for dic in messagesArray{
                let value = AMessage(fromDictionary: dic)
                messages.append(value)
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
        if messages != nil{
            var dictionaryElements = [[String:Any]]()
            for messagesElement in messages {
                dictionaryElements.append(messagesElement.toDictionary())
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
        messages = aDecoder.decodeObject(forKey: "messages") as? [AMessage]
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
        if messages != nil{
            aCoder.encode(messages, forKey: "messages")
        }
    }
}
