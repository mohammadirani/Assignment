//
//  ChatsViewController.swift
//  KeywoImage
//
//  Created by IOS Developer6 on 27/03/18.
//  Copyright © 2018 IOS Developer. All rights reserved.
//

import UIKit


class ChatsViewController: UIViewController {
    
    var searchTextfieldData = ""
    var offset = Int()
    
    var usersListObject = [ClassChatModelMessage]()
    var ClassChatModelData : ClassChatModel!
    
    private let refreshControl = UIRefreshControl()
    
    var isRefresh = Bool()



    
@IBOutlet weak var chatTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
 

        ///
//        getAllChatApi()
        // Do any additional setup after loading the view.
    }
    
    @objc func methodUIAppearanceChangedChat(notification: NSNotification) {
        
        if (notification.object != nil)  {
            
            ClassChatModelData =  nil
            offset = 1
            searchTextfieldData = notification.object as! String
            getAllUserChatListApiCall(search:searchTextfieldData)
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        Utility_Swift.setChatId("")
        chatTableView.isHidden = true
        registerNibForTableViewCell()
        /////remove extra seprator lines in tableView
        chatTableView.tableFooterView = UIView(frame: .zero)
        offset = 1
        
        getAllUserChatListApiCall(search: searchTextfieldData)
        
        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: UIControl.Event.valueChanged)
        chatTableView.addSubview(refreshControl)
        
        NotificationCenter.default.addObserver(self, selector:#selector(ChatsViewController.methodUIAppearanceChangedChat(notification:)) , name: NSNotification.Name(rawValue:"Chats"), object:nil)
        
    }
    
    @objc private func refresh(_ sender: Any) {
        ClassChatModelData = nil
        offset = 1
        self.getAllUserChatListApiCall(search: searchTextfieldData)
    }
    
    ////MARK :- Get all User Chat List.
    func getAllUserChatListApiCall(search: String)
    {
        if (Utility_Swift.isInternetConnected(isShowPopup: true)) {
            
            var url = ""
            if search == ""
            {
                url = BASE_URL + GET_CHAT + "\(offset)"
            }
            else
            {
                url = BASE_URL + GET_CHAT + "\(offset)" + "/" + search
            }
            

            
            APIManagerClass.sharedManagerClass.hitAPIWithURL(apiURL: url, methodType: .get, dictionaryParameters: nil, isNew: false, isShowProgress: true, viewCurrent: self.view, completionHandlerSuccess: { (responseJSON) in
                

                   print(responseJSON)
                if let tempResponseDict = responseJSON as? [String:Any] {

                    
                    if tempResponseDict.keys.contains("statusCode") {
                        self.chatTableView.isHidden = false
                        
                        if tempResponseDict["statusCode"] as! Int == 200 {
                            if self.ClassChatModelData != nil && self.ClassChatModelData.message != nil && self.offset == 1
                            {
                                self.self.ClassChatModelData.message.removeAll()
                            }
                            let responseObject = ClassChatModel.init(fromDictionary: tempResponseDict)
                            print(responseObject)
                            
                            if (self.ClassChatModelData != nil) {
                                self.ClassChatModelData.message.append(contentsOf: responseObject.message)
                            }
                            else {
                                self.ClassChatModelData = responseObject
                            }
                            
                            if responseObject.message.count < 4
                            {
                                self.isRefresh = true
                            }
                            else
                            {
                                self.isRefresh = false
                                
                            }
                            
                            self.refreshControl.endRefreshing()
                            self.chatTableView.reloadData()

                        }
                        else{
                            
                            self.refreshControl.endRefreshing()
                            self.chatTableView.reloadData()
                            // self.errorScreen.isHidden = false
                            //  self.errorMessage.text = (tempResponseDict["message"] as? String ?? "")
                            
                        }
                        
                    }
                }
                
            }, completionHandlerFailure: { (error) in
                print(error?.localizedDescription as Any)
            })
        }
    }
    
    
//    func timeStampToTime2(timeStemp:Double) -> String {
//        let date = Date(timeIntervalSince1970: TimeInterval(timeStemp))
//        let dateFormatter = DateFormatter()
//        dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
//        dateFormatter.locale = NSLocale.current
//        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" //Specify your format that you want
//        let strDate = dateFormatter.string(from: date)
//        let currentDate = UTCToLocal2(UTCDateString: strDate)
//        let latestDate = dateFormatter.date(from: currentDate)
//        return (latestDate?.timeAgoSinceDate())!
//    }
    
    
    func UTCToLocal2(UTCDateString: String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" //Input Format
        // dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        let UTCDate = dateFormatter.date(from: UTCDateString)
        dateFormatter.dateFormat = "yyyy-MMM-dd hh:mm:ss" // Output Format
        dateFormatter.timeZone = TimeZone.current
        let UTCToCurrentFormat = dateFormatter.string(from: UTCDate!)
        return UTCToCurrentFormat
    }

    
//    /// api for chat
//    func getAllChatApi() {
//
//        if (Utility_Swift.isInternetConnected(isShowPopup: true)) {
//
//            let dictParameters: NSMutableDictionary = ["email":Utility_Swift.getEmail(),
//
//                                                       "public_key":Utility_Swift.getPublicKey()
//            ]
//
//            let stringDataToGenerateSignature = "email=\(Utility_Swift.getEmail())" + "&public_key=\(Utility_Swift.getPublicKey())"
//
//            APIManagerClass.sharedManagerClass.hitAPIWithURL(apiURL: BASE_URL + GET_CHAT, methodType: .post, dictionaryParameters: dictParameters, isNew: false , isShowProgress: true, viewCurrent: self.view, completionHandlerSuccess: { (responseInJSON) in
//
//                print(responseInJSON)
//                if let tempResponseDict = responseInJSON as? NSDictionary {
//
//
//                }
//            }, completionHandlerFailure: { (error) in
//                print(error?.localizedDescription as Any)
//            })
//        }
//    }
    

}


extension ChatsViewController : UITableViewDelegate,UITableViewDataSource{
    
    func registerNibForTableViewCell() {
        
        chatTableView.register(UINib(nibName: "ChatsTableViewCell", bundle: nil), forCellReuseIdentifier: "ChatsTableViewCell")
        chatTableView.register(UINib(nibName: "NoRecordCell", bundle: nil), forCellReuseIdentifier: "NoRecordCell")

        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       // return usersListObject.count
        
        if self.ClassChatModelData != nil{
            return ClassChatModelData.message.count
        }
        else
        {
            return 1
        }
    }
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        if ClassChatModelData != nil{
//            if indexPath.row == ClassChatModelData.message.count - 1 { // last cell
//                    offset += 1
//                    getAllUserChatListApiCall(search:searchTextfieldData) // increment `fromIndex` by 20 before server call
//
//            }
//        }
//    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        // UITableView only moves in one direction, y axis
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        // Change 10.0 to adjust the distance from bottom
        if isRefresh == false
        {
            if maximumOffset - currentOffset <= 30.0 {
                offset += 1
                getAllUserChatListApiCall(search: searchTextfieldData)
            }
        }

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if self.ClassChatModelData != nil{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatsTableViewCell", for: indexPath) as! ChatsTableViewCell
        //////
         
        let Obj = ClassChatModelData.message[indexPath.row]
            
        let userFirstName = Obj.firstName
        let userLastName = Obj.lastName
         if let dataTimeST = Obj.createdAt
         {
            let date = Date(timeIntervalSince1970: TimeInterval(dataTimeST))
            cell.userMessageTimeLabelOutlet.text = date.timeAgoDisplay()
        }
        
        let profileImageLink = Obj.image
        

        
        cell.userNameLabelOutlet.text = userFirstName! + " " + userLastName!
        cell.userMessageLabelOutlet.text = Obj.message
        
        if (profileImageLink != nil && profileImageLink != "" && profileImageLink != " "){
            cell.userImageView.pin_updateWithProgress = true
            cell.userImageView.pin_setPlaceholder(with: UIImage(named: "ProfileDefault.png"))
            cell.userImageView.pin_setImage(from: URL(string: profileImageLink!), completion: { (result) in
                if (result.image != nil) {
                    cell.userImageView.image = Utility_Swift.cropToBounds(image:cell.userImageView.image!, width: Double(cell.userImageView.frame.size.width), height: Double(cell.userImageView.frame.size.height))
                }
            })

        }
            

        
        cell.userImageView.layer.cornerRadius = cell.userImageView.frame.size.width/2
        cell.userImageView.layer.borderWidth = 1
        cell.userImageView.layer.borderColor = UIColor.init(hex: "263238").cgColor
        
        
        cell.selectionStyle = .none
        
        return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "NoRecordCell", for: indexPath) as! NoRecordCell
            return cell
        }
    }
    
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let chat_Id = ClassChatModelData.message[indexPath.row].chatId
       {
        let userFName = ClassChatModelData.message[indexPath.row].firstName
        let userLName = ClassChatModelData.message[indexPath.row].lastName
        let userAccountHandle = ClassChatModelData.message[indexPath.row].accountHandle
        let user_Id = ClassChatModelData.message[indexPath.row].userId
        let image = ClassChatModelData.message[indexPath.row].image

        let VC1 = self.storyboard!.instantiateViewController(withIdentifier: "OneToOneChatViewController") as! OneToOneChatViewController
        VC1.recUserChatId = chat_Id
        VC1.recUserName = userFName! + " " + userLName!
        VC1.recAccountHandle = "@" + userAccountHandle!
        VC1.userID = user_Id!
        VC1.recUserImage = image!

        let navController = UINavigationController(rootViewController: VC1) // Creating a navigation controller with VC1 at the root of the navigation stack.
        self.present(navController, animated:true, completion: nil)
        
        }
        
    }

}
