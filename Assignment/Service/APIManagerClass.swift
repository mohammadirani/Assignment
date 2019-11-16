//
//  APIManagerClass.swift
//  Assignment
//
//  Created by Sachin on 16/11/19.
//  Copyright © 2019 Sachin. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import CodableAlamofire

class APIManagerClass: NSObject {
    
    static let sharedManagerClass = APIManagerClass()
    
    func getCurrentMillis()->Int64 {
        return Int64(Date().timeIntervalSince1970 * 1000)
    }
    
    
    func hitAPIWithURL(apiURL: String,methodType:HTTPMethod,dictionaryParameters: [String:Any]?, completionHandlerSuccess: @escaping (_ responseInJSON: Any) -> Void, completionHandlerFailure: @escaping (_ error: Error?) -> Void ) {
        
    
            UIApplication.shared.isNetworkActivityIndicatorVisible = true

            Alamofire.SessionManager.default.session.configuration.timeoutIntervalForRequest = 30
        
    
            print("url = \(apiURL)")
            
            switch methodType {
            case  .post :
                    print("In post")
                
                    Alamofire.request(apiURL, method: .post, parameters: (dictionaryParameters), encoding: JSONEncoding.default, headers: nil)
                                      .responseJSON { (response) in
                                          
                                          print("response = \(response)")
                                          
                                          let jsonData = response.value as? [String:Any]
                                          print("response = \(String(describing: jsonData))")
                                          
                                          
                                          if let status = response.response?.statusCode {
                                              switch(status){
                                                  
                                              case 200:
                                                  let populatedDictionary = ["statusCode": response.response!.statusCode,"message":response.value,"url": response.request?.url]
                                                  completionHandlerSuccess(populatedDictionary)
                                              default:
                                                  completionHandlerFailure(response.value as? Error)
                                              }
                                          }
                                          else{
                                              completionHandlerFailure(response.error)
                                          }
                                          UIApplication.shared.isNetworkActivityIndicatorVisible = false
                                        
                                  }
            case .get:
               print("In Get")
            case .put:
                print("In Put")
            case .delete:
                print("In Delete")
            default:
                print("In Default")
            }
        }
    }
    


