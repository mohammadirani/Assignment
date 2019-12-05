//
//  OneToOneChatVC+optionsAPI.swift
//  Postgram
//
//  Created by mohammed on 19/02/19.
//  Copyright © 2019 IOS Developer. All rights reserved.
//

import Foundation
import UIKit


extension OneToOneChatViewController
{
    /////MARK :- Mail Chat
    func mailChatMessagesApiNetworkCall()
    {
         if (Utility_Swift.isInternetConnected(isShowPopup: true)) {
            
            /////Create Dictionary
            let dictParameters: NSMutableDictionary = [
                "chat_id": recUserChatId
            ]
            
            let url = BASE_URL + EMAIL_CHAT
            
            
            
            APIManagerClass.sharedManagerClass.hitAPIWithURL(apiURL: url, methodType: .post, dictionaryParameters: dictParameters, isNew: false, isShowProgress: true, viewCurrent: self.view, completionHandlerSuccess: { (responseJSON) in
             //   print(responseJSON)
                if let tempResponseDict = responseJSON as? [String:Any] {
                    if tempResponseDict.keys.contains("statusCode") {
                        if tempResponseDict["statusCode"] as! Int == 200 {
                        
                            

                        print(responseJSON)
                            let message = tempResponseDict["message"] as? [String:Any]
                            if let messagerec = message?["message"] as? String
                            {
                                // the alert view
                                let alert = UIAlertController(title: "", message: messagerec, preferredStyle: .alert)
                                self.present(alert, animated: true, completion: nil)
                                let when = DispatchTime.now() + 3
                                DispatchQueue.main.asyncAfter(deadline: when){
                                    // your code with delay
                                    alert.dismiss(animated: true, completion: nil)
                                }
                            }
                        }}
                }
                
            }, completionHandlerFailure: { (error) in
                print(error?.localizedDescription as Any)
            })
        }
        
    }
    
    /////MARK :- Clear Chat
    func clearChatMessagesApiNetworkCall()
    {
        if (Utility_Swift.isInternetConnected(isShowPopup: true)) {
            
            /////Create Dictionary
            let dictParameters: NSMutableDictionary = [
                "chat_id": recUserChatId
            ]
            
            let url = BASE_URL + CLEAR_CHAT
            
            

            
            APIManagerClass.sharedManagerClass.hitAPIWithURL(apiURL: url, methodType: .post, dictionaryParameters: dictParameters, isNew: false, isShowProgress: true, viewCurrent: self.view, completionHandlerSuccess: { (responseJSON) in
                //   print(responseJSON)
                if let tempResponseDict = responseJSON as? [String:Any] {
                    if tempResponseDict.keys.contains("statusCode") {
                        if tempResponseDict["statusCode"] as! Int == 200 {
                            
                            

                            print(responseJSON)
                            let message = tempResponseDict["message"] as? [String:Any]
                            if let messagerec = message?["message"] as? String
                            {
                                // the alert view
                                let alert = UIAlertController(title: "", message: messagerec, preferredStyle: .alert)
                                self.present(alert, animated: true, completion: nil)
                                let when = DispatchTime.now() + 3
                                DispatchQueue.main.asyncAfter(deadline: when){
                                    // your code with delay
                                    alert.dismiss(animated: true, completion: nil)
                                }
                            }

                            ///MARK :- After clearing remove all values in chat And reload tableView
                           self.chatListObject.removeAll()
                           self.tableViewChat.reloadData()
                        }}
                }
                
            }, completionHandlerFailure: { (error) in
                print(error?.localizedDescription as Any)
            })
        }

    }
    
    /////MARK :- Block or Unblock User
    func blockOrUnblockUserApiNetworkCall()
    {
        print("Block Network Call")
        
        var postBlockUnBlockStatus = Int()
        
        if blockUnblockStatus == 1
        {
            postBlockUnBlockStatus = 0
        }
        else
        {
            postBlockUnBlockStatus = 1
        }
        if (Utility_Swift.isInternetConnected(isShowPopup: true)) {
            
            let url = BASE_URL + BLOCK_CHAT
            
//                {
//                    "chat_id":"5b87d6361222e30f5125e16b",
//                    "block_status":1      1=>Block, 0=>Unblock
//                }
            
            let dictParameters: NSMutableDictionary = [
                "chat_id":recUserChatId,
                "block_status": postBlockUnBlockStatus
            ]
            
            

            APIManagerClass.sharedManagerClass.hitAPIWithURL(apiURL: url, methodType: .post, dictionaryParameters: dictParameters, isNew: false, isShowProgress: true, viewCurrent: self.view, completionHandlerSuccess: { (responseJSON) in
                print(responseJSON)
                

                if let tempResponseDict = responseJSON as? [String:Any] {
                    if tempResponseDict.keys.contains("statusCode") {
                        if tempResponseDict["statusCode"] as! Int == 200 {
                            
                            print(responseJSON)
                            let message = tempResponseDict["message"] as? [String:Any]
                            if let messagerec = message?["message"] as? String
                            {
                                // the alert view
                                let alert = UIAlertController(title: "", message: messagerec, preferredStyle: .alert)
                                self.present(alert, animated: true, completion: nil)
                                let when = DispatchTime.now() + 3
                                DispatchQueue.main.asyncAfter(deadline: when){
                                    // your code with delay
                                    alert.dismiss(animated: true, completion: nil)
                                }
                            }
                            
                            if self.blockUnblockStatus == 1
                            {
                               // "User unblocked successfully"
                                self.blockUnblockStatus = 0
                                
                                self.socketIOClient.connect()
                                self.createRoom()
                                
                                self.bottomViewOutlet.isHidden = false
                                self.unBlockButtonOutlet.isHidden = true
                            }
                            else
                            {
                                /////"User blocked successfully"
                                self.blockUnblockStatus = 1
                                self.socketIOClient.disconnect()
                                
                                self.bottomViewOutlet.isHidden = true
                                self.unBlockButtonOutlet.isHidden = false
                            }
                        }}
                }
                
            }, completionHandlerFailure: { (error) in
                print(error?.localizedDescription as Any)
            })
        }
    }

}
