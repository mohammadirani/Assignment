//
//  OneToOneChat+SocketIO.swift
//  Postgram
//
//  Created by mohammed on 11/02/19.
//  Copyright © 2019 IOS Developer. All rights reserved.
//

import UIKit
import SocketIO

extension OneToOneChatViewController
{
    //////connect to Socket
   func ConnectToSocket()
   {
      ////previ URL : http://13.233.33.131:3200/
      /////new : "https://socket.postgram.xyz"
    
    manager = SocketManager(socketURL: URL(string: "https://chat.postgram.com/")!, config: [.log(true), .forceNew(true)])
    socketIOClient = manager.defaultSocket
    
    }
    
    func onEventsOfSocket()
    {
     
        socketIOClient.on(clientEvent: .connect) {data, ack in
            print(data)
            print("socket connected")
            self.createRoom()
        }
        
        socketIOClient.on(clientEvent: .error) { (data, eck) in
            print(data)
            print("socket error")
        }
        
        socketIOClient.on("typing") {data, ack in
            print("typing")
            self.userHandle.text = "typing..."
        }
        socketIOClient.on("stop_typing") {data, ack in
            self.userHandle.text = self.recAccountHandle
        }
        
        socketIOClient.on(clientEvent: .disconnect) { (data, eck) in
            print(data)
            print("socket disconnect")
            // the alert view
//            let alert = UIAlertController(title: "", message: "Socket disconnect!!!!!!", preferredStyle: .alert)
//            self.present(alert, animated: true, completion: nil)
//            let when = DispatchTime.now() + 3
//            DispatchQueue.main.asyncAfter(deadline: when){
//                // your code with delay
//                alert.dismiss(animated: true, completion: nil)
//            }
        }
        
        socketIOClient.on(clientEvent: SocketClientEvent.reconnect) { (data, eck) in
            print(data)
            print("socket reconnect")
            
        }
        
        /////////// Receive event : Recieves the message from Server or User
        socketIOClient.on("rec_message") {data, ack in
            // print(data)
            if let list = data as? NSArray {
                for i in 0 ..< list.count {
                    if let res = list[i] as? NSDictionary{
                        print(res)
                        let UserMessagesObject = AMessage.init(fromDictionary: res as! [String : Any])
                        let date = Date()
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "h:mm a"
                        let result = dateFormatter.string(from: date)
                        print(result)
                        // convert Date to TimeInterval (typealias for Double)
                        let timeInterval = date.timeIntervalSince1970
                        // convert to Integer
                        let myInt = Int(timeInterval)
                        // convert Int to Double
                        let timeInterval2 = Double(myInt)
                        // convert Double to String
                        let FinalD = String(timeInterval2)
                        
                        UserMessagesObject.createdAt = FinalD
                        
                        // self.chatListObject =  self.chatListObject.reversed()
                        self.chatListObject.append(UserMessagesObject)
                        //  self.chatListObject =  self.chatListObject.reversed()
                    }
                }
            }
            self.tableViewChat.isHidden = false
            self.tableViewChat.reloadData()
            
        }
        
        //new_message request:  {"chat_id": "ccc","message":"Hello, how are you?","user_id":"1"}
        // events            :  1:create 2:new_message 3:rec_message
        ///UrL               :  http://13.233.33.131:3200/
        
        socketIOClient.connect()
        
    }
    
//    func generateCurrentTimeStamp () -> String {
//        let formatter = DateFormatter()
//        formatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
//        formatter.locale = NSLocale.current
//        return (formatter.string(from: Date()) as NSString) as String
//    }
    
    ///////Create Room
    func createRoom()
    {
         socketIOClient.emit("create", recUserChatId)

    }
}
extension Date {
    func currentTimeMillis() -> String! {
        return String(self.timeIntervalSince1970 * 1000)
    }
}
