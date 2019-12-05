//
//  ChatDataModel.swift
//  KeywoImage
//
//  Created by IOS Developer6 on 28/03/18.
//  Copyright © 2018 IOS Developer. All rights reserved.
//

import Foundation

class ChatDataModel: NSObject {
    var chatMessage: String?
    var userName: String?
    var isSender: Bool?
    
    //////new changes Chat Model
    var chat_id: String?
    var user_id: String?
    var account_handle: String?
    var email: String?
    var first_name: String?
    var last_name: String?
    var image: Any?
    var message: String?
    var created_at: Int?
    var last_message_time: Int?

    init?(data: [String:Any]) {
        self.chat_id = data["chat_id"] as? String ?? "NA"
        self.user_id = data["user_id"] as? String ?? "NA"
        self.account_handle = data["account_handle"] as? String ?? "NA"
        self.email = data["email"] as? String ?? "NA"
        self.first_name = data["first_name"] as? String ?? "NA"
        self.last_name = data["last_name"] as? String ?? "NA"
        self.image = data["image"] as Any
        self.message = data["message"] as? String ?? "NA"
        self.created_at = data["created_at"] as? Int ?? 0
        self.last_message_time = data["last_message_time"] as? Int ?? 0

    }
    
    override init() {
        
    }
    
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if account_handle != nil{
            dictionary["account_handle"] = account_handle
        }
        if chat_id != nil{
            dictionary["chat_id"] = chat_id
        }
        if created_at != nil{
            dictionary["created_at"] = created_at
        }
        if email != nil{
            dictionary["email"] = email
        }
        if first_name != nil{
            dictionary["first_name"] = first_name
        }
        if image != nil{
            dictionary["image"] = image
        }
        if last_name != nil{
            dictionary["last_name"] = last_name
        }
        if message != nil{
            dictionary["message"] = message
        }
        if user_id != nil{
            dictionary["user_id"] = user_id
        }
        if last_message_time != nil{
            dictionary["last_message_time"] = last_message_time
        }
        return dictionary
    }
    
    
    
}



//[
//    {
//        "chat_id": "2a62ac0f-571b-483c-a9c3-e1108568b4fd",
//        "user_id": "5b87d6791222e30f5125e177",
//        "account_handle": "vihan701",
//        "email": "vihan701@grr.la",
//        "first_name": "Shikhar",
//        "last_name": "Dhawan",
//        "image": null,
//        "message": "GM",
//        "created_at": 1548220969
//    }
//]
