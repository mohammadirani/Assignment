//
//  OneToOneChatViewController.swift
//  KeywoImage
//
//  Created by IOS Developer6 on 28/03/18.
//  Copyright © 2018 IOS Developer. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import DropDown
import SocketIO
import ReverseExtension




class OneToOneChatViewController: UIViewController {
    
  
    @IBOutlet weak var tableViewBottomContraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConOutlet: NSLayoutConstraint!
    @IBOutlet weak var userHandleButtonOutlet: UIButton!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var userHandle: UILabel!
    @IBOutlet weak var coustomNevigationBar: UIView!
    
    @IBOutlet weak var bottomOutletHeight: NSLayoutConstraint!
    @IBOutlet weak var userProfileImageOutlet: UIImageView!
    @IBOutlet weak var tableViewChat: UITableView!
    
    var userID = String()
    var chatCount = Int()
    @IBOutlet weak var messageTextView: UITextView!
    
    @IBOutlet weak var unBlockButtonOutlet: UIButton!
    @IBOutlet weak var bottomViewOutlet: UIView!
    var keyboardHeight : CGFloat = 0.0
    var chatListObject = [AMessage]()
    var chatListObjectNew = [UserMessagesNewMessagesNew]()
    var userIdObject = [GetUserIdMessage]()
    var chatListObjectModel = [[UserMessagesMessage]]()
    var keyboardOn = false
    var newObjectChat = [AMessage]()

    @IBOutlet weak var textViewBackgroundViewHeightConstraint: NSLayoutConstraint!
    
    var recUserChatId = ""
    var recUserName = ""
    var recAccountHandle = ""
    var recUserImage = ""
    var searchTextfieldData = ""
    var offset = Int()
    var limit = Int()
    var topDateG = ""
    
    ////MARK :- Block Status
    var blockUnblockStatus = Int()
    
    
    /////MARK -: Socket variable
    var manager:SocketManager!
    var socketIOClient: SocketIOClient!
    
    var hasTopNotch: Bool {
        if #available(iOS 11.0, tvOS 11.0, *) {
            return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 20
        }
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        
         Utility_Swift.setChatId("")
        
        registerTableViewNib()
        
        IQKeyboardManager.sharedManager().enableAutoToolbar = false
        IQKeyboardManager.sharedManager().enable = false
        
        messageTextView.delegate = self
        messageTextView.layer.borderColor = UIColor.init(hex: "9A9A9A").cgColor
        
        /////MARK -: ReverseExtension for TableView Delegates
        tableViewChat.re.dataSource = self
        //You can apply reverse effect only set delegate.
        tableViewChat.re.delegate = self
        /////MARK -: ReverseExtension for TableView using Pagination Network Call on Scroll.
        tableViewChat.re.scrollViewDidReachTop = { scrollView in
            self.offset = self.offset + 1
            self.getAllChatMessagesApicall(search: self.searchTextfieldData)
            print("scrollViewDidReachTop")
        }
        tableViewChat.re.scrollViewDidReachBottom = { scrollView in
            print("scrollViewDidReachBottom")
        }
        /////MARK -: ReverseExtension for TableView using Pagination Network Call on Scroll.

        self.coustomNevigationBar?.layer.shadowColor = UIColor.black.cgColor
        self.coustomNevigationBar?.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        self.coustomNevigationBar?.layer.shadowRadius = 1.0
        self.coustomNevigationBar?.layer.shadowOpacity = 0.3
        self.coustomNevigationBar?.layer.masksToBounds = false
        self.coustomNevigationBar?.tintColor = UIColor.black
        
        /////MARK -: Set offset And Limit For User Message List.
        offset = 1
        limit = 25
        
        /////MARK -: Check If User hs chat Id then call GetAllMessages, else then Call Network to getCahat Id.

        if recUserChatId.isEmpty
        {
            /////get Chat_Id Api Call
            getChatIdApiCall()
            
        }
        else
        {
            ///////Get All messages Api call
            getAllChatMessagesApicall(search: searchTextfieldData)

        }
        
        // Do any additional setup after loading the view.
        
        userNameLbl.text = recUserName
        userHandle.text = recAccountHandle
        
        ////////MARK :- Receiver User Profile Image.
        let profileImageLink = recUserImage
        if (profileImageLink != nil && profileImageLink != "" && profileImageLink != " "){

            profileImg.pin_updateWithProgress = true
            profileImg.pin_setImage(from: URL(string: profileImageLink), placeholderImage: UIImage(named: "ProfileDefault.png"))
            profileImg.image = Utility_Swift.cropToBounds(image:profileImg.image!, width: Double(profileImg.frame.size.width), height: Double(profileImg.frame.size.height))


       }
        
        profileImg.layer.cornerRadius = profileImg.frame.size.width/2
        profileImg.layer.borderWidth = 1
        profileImg.layer.borderColor = UIColor.init(hex: "263238").cgColor

//
        ///MARK :- User Account Profile Image
        let profileImageLink2 = Utility_Swift.getProfilePic()
        if (profileImageLink2 != ""){            
            userProfileImageOutlet.pin_updateWithProgress = true
            userProfileImageOutlet.pin_setImage(from: URL(string: profileImageLink2), placeholderImage: UIImage(named: "ProfileDefault.png"))
            userProfileImageOutlet.image = Utility_Swift.cropToBounds(image:userProfileImageOutlet.image!, width: Double(userProfileImageOutlet.frame.size.width), height: Double(userProfileImageOutlet.frame.size.height))
        }
        
        userProfileImageOutlet.layer.cornerRadius = userProfileImageOutlet.frame.size.width/2
        userProfileImageOutlet.layer.borderWidth = 0.5
        userProfileImageOutlet.layer.borderColor = UIColor.init(hex: "263238").cgColor
        userProfileImageOutlet.clipsToBounds = true
        //////connect to Socket
         ConnectToSocket()
         onEventsOfSocket()
        
    }
    
   
    
     @objc func keyboardWillShow(_ notification: Notification) {
        self.keyboardOn = true
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            keyboardHeight = keyboardRectangle.height
             if hasTopNotch{
                self.bottomConOutlet.constant = (keyboardHeight - 30)
                self.tableViewBottomContraint.constant = ((keyboardHeight - 30) + self.bottomViewOutlet.frame.height)
            }
            else
             {
                self.bottomConOutlet.constant = (keyboardHeight)
                self.tableViewBottomContraint.constant = (keyboardHeight + self.bottomViewOutlet.frame.height)
            }
  
        }
    }
     @objc func keyboardWillHide(_ notification: Notification) {
        self.bottomConOutlet.constant = 0
        keyboardHeight = 0
        keyboardOn = false
        
        self.tableViewBottomContraint.constant = 40
    }
    
    @IBAction func userHandleButtonTapped(_ sender: Any) {
        
        let StoryboardObject = UIStoryboard(name: TAB_BAR_STORYBOARD, bundle: nil)
        let vc = StoryboardObject.instantiateViewController(withIdentifier: ProfileController.identifier) as! ProfileController
      //  vc.hashtag = self.hashTagModelData.list[indexPath.row].keyword.replacingOccurrences(of: "#", with: "")
        vc.isFrom = "other"
        vc.targetUserId =  userID
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    /////MARK :- get Chat_Id Api Call
    func getChatIdApiCall()
    {
        if (Utility_Swift.isInternetConnected(isShowPopup: true)) {
            
           let url = BASE_URL + GET_CHAT_ID + userID
            
            

            
            APIManagerClass.sharedManagerClass.hitAPIWithURL(apiURL: url, methodType: .get, dictionaryParameters: nil, isNew: false, isShowProgress: false, viewCurrent: nil, completionHandlerSuccess: { (responseJSON) in
                print(responseJSON)
                

                if let tempResponseDict = responseJSON as? [String:Any] {
                    if tempResponseDict.keys.contains("statusCode") {
                        if tempResponseDict["statusCode"] as! Int == 200 {
                            let message = tempResponseDict["message"] as? [String:Any]
                            if let UserChatId = message?["chat_id"] as? String
                            {
                               self.recUserChatId = UserChatId
                                ///////Get All messages Api call
                                self.setChatIdOne()
                                self.getAllChatMessagesApicall(search: self.searchTextfieldData)
                               self.createRoom()
                            }
                        }}
                }
            }, completionHandlerFailure: { (error) in
                print(error?.localizedDescription as Any)
            })
        }
    }
    
    /////MARK :- get All Chat Messages Api Call
    func getAllChatMessagesApicall(search: String)
    {
        if (Utility_Swift.isInternetConnected(isShowPopup: true)) {
            
            var url = ""
            if search == ""
            {
                url = BASE_URL + GET_CHAT_MESSAGES + "\(recUserChatId)" + "/" + "\(offset)" + "/" + "\(limit)"
            }
            
            

            
            APIManagerClass.sharedManagerClass.hitAPIWithURL(apiURL: url, methodType: .get, dictionaryParameters: nil, isNew: false, isShowProgress: true, viewCurrent: self.view, completionHandlerSuccess: { (responseJSON) in
                    print(responseJSON)
                

                if let tempResponseDict = responseJSON as? [String:Any] {
                    if tempResponseDict.keys.contains("statusCode") {
                        if tempResponseDict["statusCode"] as! Int == 200 {
                            
                            let responseObject = UserMessagesNew.init(fromDictionary: tempResponseDict)
                            print(responseObject)
                            
                            if let resW = tempResponseDict["message"] as? [String:Any] {
                                
                                let res = A.init(fromDictionary: resW)
                                print(res)
                                
                                let bl = res.isBlocked
                                
                                self.blockUnblockStatus = bl!
                                
                                if self.blockUnblockStatus == 1
                                {
                                    self.socketIOClient.disconnect()
                                    //self.socketIOClient.leaveNamespace()
                                    self.bottomViewOutlet.isHidden = true
                                    self.unBlockButtonOutlet.isHidden = false
                                }
                                else
                                {
                                    self.bottomViewOutlet.isHidden = false
                                    self.unBlockButtonOutlet.isHidden = true
                                }
                                
                                if (!self.chatListObject.isEmpty) {
                                    print(self.chatListObject)
                                    self.chatListObject =  self.chatListObject.reversed()
                                    self.chatListObject.append(contentsOf: res.messages)
                                    self.chatListObject =  self.chatListObject.reversed()
                                    self.tableViewChat.reloadData()
                                    
                                }
                                else {
                                    print(self.chatListObject)
                                    self.chatListObject = res.messages
                                 //   self.chatListObjectNew = (UsersMessage?[0].messagesNew)!
                                    self.chatListObject =  self.chatListObject.reversed()
                                    
                                    //                                var indexAll: Int = 0
                                    //                                if self.chatListObject.count > 0
                                    //                                {
                                    //                                    for i in 1...self.chatListObject.count {
                                    //                                        let d = self.chatListObject[indexAll]
                                    //                                        let dee = d.createdAt
                                    //                                        let de = self.timeStampToTime2(timeStemp: Double(dee!)!)
                                    //                                        let  c = self.dateFromCustomString(customString: de)
                                    //                                       self.chatListObject[indexAll].date = c
                                    //                                        indexAll = indexAll + 1
                                    //                                    }
                                    //                                }
                                    self.tableViewChat.reloadData()
                                }
                                
                            }
                            
                            
                        
                            

                        }}
                }
            }, completionHandlerFailure: { (error) in
                print(error?.localizedDescription as Any)
            })
        }
    }
    
    ////
    @IBAction func unBlockButtonTapped(_ sender: Any) {
        
//        self.blockUnblockStatus = 0
//
//        self.ConnectToSocket()
//        self.createRoom()
//
//        self.bottomViewOutlet.isHidden = false
//        self.unBlockButtonOutlet.isHidden = true
        
        
        blockOrUnblockUserApiNetworkCall()
        
    }
    

    
    /////MARK :- Convert TimeStamp to Time.
    func timeStampToTime(timeStemp:Double) -> String {
        
        let date = Date(timeIntervalSince1970: TimeInterval(timeStemp))
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" //Specify your format that you want
        let strDate = dateFormatter.string(from: date)
        let currentDate = UTCToLocal(UTCDateString: strDate)
        
      //  let latestDate = dateFormatter.date(from: currentDate)
        
        return currentDate
    }
    func UTCToLocal(UTCDateString: String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" //Input Format
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        let UTCDate = dateFormatter.date(from: UTCDateString)
        dateFormatter.dateFormat = "h:mm a" // Output Format
        dateFormatter.timeZone = TimeZone.current
        let UTCToCurrentFormat = dateFormatter.string(from: UTCDate!)
        return UTCToCurrentFormat
    }
    
    func convertTimeIntervalToDate(timeST: Double) -> String
    {
        let dateFormatter = DateFormatter()
        // create NSDate from Double (NSTimeInterval)
        let myNSDate = Date(timeIntervalSince1970: timeST)
        dateFormatter.dateFormat = "MMM d, yyyy"
        let result2 = dateFormatter.string(from: myNSDate)
        print(result2)
        return result2
    }
    
//    fileprivate func attemptToAssembleGroupedMessages() {
//        print("Attempt to group our messages together based on Date property")
//
//        let groupedMessages = Dictionary(grouping: chatListObject) { (element) -> Date in
//           // return element.createdAt
//            return element.date.reduceToMonthDayYear()
//        }
//
//        // provide a sorting for your keys somehow
//        let sortedKeys = groupedMessages.keys.sorted()
//        sortedKeys.forEach { (key) in
//            let values = groupedMessages[key]
//            chatListObjectModel.append(values ?? [])
//        }
//    }
    

    
    
//    /////////Table content to Bottom
//    func updateTableContentInset() {
//        let numRows = tableView(self.tableViewChat, numberOfRowsInSection: 0)
//        var contentInsetTop = self.tableViewChat.bounds.size.height
//        for i in 0..<numRows {
//            let rowRect = self.tableViewChat.rectForRow(at: IndexPath(item: i, section: 0))
//            contentInsetTop -= rowRect.size.height
//            if contentInsetTop <= 0 {
//                contentInsetTop = 0
//            }
//        }
//        self.tableViewChat.contentInset = UIEdgeInsets(top: contentInsetTop, left: 0, bottom: 0, right: 0)
//    }
    
    
    func scrollToFirstRow() {
        let indexPath = IndexPath(row: 0, section: 0)
        self.tableViewChat.scrollToRow(at: indexPath, at: .top, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        setChatIdOne()
        
    }
    
    func setChatIdOne()
    {
        Utility_Swift.setChatId(recUserChatId)
        
        let chatD = Utility_Swift.getChatId()
        print(chatD)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
       // createRoom()
    }
    
    
    @IBAction func backBtnAction(_ sender: UIButton) {
       dismiss(animated: true, completion: nil)
     //   self.navigationController?.popViewController(animated: true)
    }
    
    // MARK :- Send Message to Socket and Server
    @IBAction func sendBtnMsg(_ sender: UIButton) {
        
        if validate(textView: self.messageTextView!) {
            // do something
            print("Valid")
            
            if self.messageTextView.text != nil && self.messageTextView.text != "" {
                
                let requestModel = AMessage()
                let chat_id = recUserChatId
                requestModel.chatId = chat_id
                let message = messageTextView.text
                requestModel.message = message
                let user_id = Utility_Swift.getUserId()
                requestModel.userId = user_id
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
                requestModel.createdAt = String(timeInterval2)
                //  requestModel.date = date
                let id = "0"
                requestModel.id = id
                let is_read = 0
                requestModel.isRead = is_read
                ////Add Chat message to Model
                chatListObject.append(requestModel)
                tableViewChat.beginUpdates()
                tableViewChat.re.insertRows(at: [IndexPath(row: chatListObject.count - 1, section: 0)], with: .none)
                tableViewChat.endUpdates()
                
                let  para = requestModel.toDictionary()
                print(para)
                //////send Message to socket
                socketIOClient.emit("new_message", para)
                //////Send Message to server
                sendMessageToServer(para: para)
               messageTextView.text = ""
            }
        } else {
            // do something else
            print("Not Valid")
        }
        
     //   self.messageTextView.enableReturnKeyAutomatically = NO
        
       
    }
    
    func validate(textView: UITextView) -> Bool {
        guard let text = textView.text,
            !text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty else {
                // this will be reached if the text is nil (unlikely)
                // or if the text only contains white spaces
                // or no text at all
                return false
        }
        
        return true
    }
    
    
    //// MARK :- Send Message to server.
    func sendMessageToServer(para: [String: Any])
    {
        if (Utility_Swift.isInternetConnected(isShowPopup: true)) {
            
                let url = BASE_URL + POST_MESSAGES
           
           let dictPara = (para as NSDictionary).mutableCopy() as! NSMutableDictionary

        //
            APIManagerClass.sharedManagerClass.hitAPIWithURL(apiURL: url, methodType: .post, dictionaryParameters: dictPara, isNew: false, isShowProgress: false, viewCurrent: self.view, completionHandlerSuccess: { (responseJSON) in
                print(responseJSON)
             //   

                if let tempResponseDict = responseJSON as? [String:Any] {
                    if tempResponseDict.keys.contains("statusCode") {
                        if tempResponseDict["statusCode"] as! Int == 200 {
                            
                            let responseObject = UserMessages.init(fromDictionary: tempResponseDict)
                            print(responseObject)
                            
                            if let resW = tempResponseDict["message"] as? [String:Any] {
                                
                                let res = A.init(fromDictionary: resW)
                                print(res)
                            }
                        }}
                }
                
            }, completionHandlerFailure: { (error) in
                print(error?.localizedDescription as Any)
            })
            

        }
    }
    
    @objc func backButton (sender:UIButton!) {
       self.dismiss(animated: true, completion: nil)
    }
    
   @IBAction func optionButton (sender:UIButton!) {
    
        let dropDownPopular = DropDown()
        dropDownPopular.anchorView = sender
        dropDownPopular.bottomOffset = CGPoint.init(x: 0, y: 30)
    
    if blockUnblockStatus == 0
    {
         dropDownPopular.dataSource = ["Clear Chat","Mail Chat","Block"]
    }
    else
    {
         dropDownPopular.dataSource = ["Clear Chat","Mail Chat","Unblock"]
    }
    
    
        dropDownPopular.textColor = UIColor.black
        dropDownPopular.selectionAction = { (index: Int, item: String) in
            sender.setTitle(item,for: .normal)
            
            
                if sender.titleLabel?.text == "Clear Chat" {
                    
                    self.clearChatMessagesApiNetworkCall()
                   
                }
                else if sender.titleLabel?.text == "Mail Chat" {
                    
                    self.mailChatMessagesApiNetworkCall()
                   
                }
                else if sender.titleLabel?.text == "Block" || sender.titleLabel?.text == "Unblock" {
                   
                      self.blockOrUnblockUserApiNetworkCall()
            }
        }
        dropDownPopular.show()
    }
}

//func attemptToAssembleGroupedMessages() {
//    print("Attempt to group our messages together based on Date property")
//
//    let groupedMessages = Dictionary(grouping:chatListObjectModel ) { (element) -> Date in
//        return element.date.reduceToMonthDayYear()
//    }
//
//    // provide a sorting for your keys somehow
//    let sortedKeys = groupedMessages.keys.sorted()
//    sortedKeys.forEach { (key) in
//        let values = groupedMessages[key]
//        chatMessages.append(values ?? [])
//    }
//}


// MARK: - Extension methods for Table View

extension OneToOneChatViewController : UITableViewDelegate, UITableViewDataSource {
    
    func registerTableViewNib() {
        self.tableViewChat.register(SenderChatTableViewCell.nib, forCellReuseIdentifier: SenderChatTableViewCell.identifier)
        self.tableViewChat.register(RecieverChatTableViewCell.nib, forCellReuseIdentifier: RecieverChatTableViewCell.identifier)
    }
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return chatListObjectModel.count
//    }
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 30
//    }
//
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return chatListObject.count
    }
    
//     func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        if let firstMessageInSection = chatListObjectModel[section].first {
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "MMM, d,yyyy"
//            let dateString = dateFormatter.string(from: firstMessageInSection.date)
//
//            let label = DateHeaderLabel()
//            label.text = dateString
//
//            let containerView = UIView()
//
//            containerView.addSubview(label)
//            label.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
//            label.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
//
//            return containerView
//
//        }
//        return nil
//    }
    
    /////Enable delete message from tableView.
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle
    {
        return UITableViewCell.EditingStyle.none
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
       
        //MARK :- Logic of Sender and Receiver Text View.
        //MARK :- Logic of Date as per Messages.

        var checkDate = Bool()
        let chatSingleData = chatListObject[indexPath.row]
        tableView.separatorStyle = .none
        let dataTimeST = chatSingleData.createdAt
        let topdate = convertTimeIntervalToDate(timeST: Double(dataTimeST!)!)
        if(indexPath.row != 0)
        {
            topDateG = convertTimeIntervalToDate(timeST: Double(chatListObject[indexPath.row - 1].createdAt!)!)
        }
        
        if topdate == topDateG
        {
            checkDate = true
        }
        else
        {
            checkDate = false
        }
        if chatSingleData.userId == Utility_Swift.getUserId()  {
            let cell = tableView.dequeueReusableCell(withIdentifier: SenderChatTableViewCell.identifier, for: indexPath) as! SenderChatTableViewCell
            let currentTimeST = timeStampToTime(timeStemp: Double(dataTimeST!)!)
            cell.labelChatDate.text = currentTimeST
             if checkDate
              {
                 cell.dateViewHeightOutlet.constant = 0
               }
             else{
              cell.dateViewHeightOutlet.constant = 20
             cell.topDateLabelOutlet.text = topdate
             topDateG = topdate
            }
            cell.chatLabelData.text = chatSingleData.message
            cell.chatLabelData.sizeToFit()
            cell.selectionStyle = .none
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier:RecieverChatTableViewCell.identifier, for: indexPath) as! RecieverChatTableViewCell
           // let dataTimeST = chatSingleData.createdAt
            let currentTimeST = timeStampToTime(timeStemp: Double(dataTimeST!)!)
            cell.labelChateDate.text = currentTimeST
            
            if checkDate
            {
                cell.dateViewHeightOutlet.constant = 0
            }
            else{
                cell.dateViewHeightOutlet.constant = 20
                cell.topDateLabelOutlet.text = topdate
                topDateG = topdate
            }
            cell.chatLabelData.text = chatSingleData.message
            cell.chatLabelData.sizeToFit()
            cell.selectionStyle = .none
            return cell
        }
    }
    
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        // UITableView only moves in one direction, y axis
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        // Change 10.0 to adjust the distance from bottom
        if maximumOffset - currentOffset <= 10.0 {
            
            print("zHello")
         
            
        }
    }

}

// MARK: Extension for Text View Methods

extension OneToOneChatViewController: UITextViewDelegate {
    
    // Text View delegate methods.
    public func textViewDidEndEditing(_ textView: UITextView) {
        resizeTextView(textView: textView)
        ///////
        //////send Typing Event to Socket
        let requestModel = AMessage()
        let chat_id = recUserChatId
        requestModel.chatId = chat_id
        let user_id = Utility_Swift.getUserId()
        requestModel.userId = user_id
        let  para = requestModel.toDictionary()
        print(para)
        //////send Typing to socket
        socketIOClient.emit("stop_typing", para)
    }
    
    //MARK :- Send to Socket typing event.
    public func textViewDidChange(_ textView: UITextView) {
        resizeTextView(textView: textView)
        //////send Typing Event to Socket
        let requestModel = AMessage()
        let chat_id = recUserChatId
        requestModel.chatId = chat_id
        let user_id = Utility_Swift.getUserId()
        requestModel.userId = user_id
        let  para = requestModel.toDictionary()
        print(para)
        //////send Typing to socket
        socketIOClient.emit("typing", para)
        
    }
    
    /// Resize the textview hieght while adding text for sending message. Simultaneously change the height of table view according the height of text view.
    ///
    /// - Parameter textView: Textviw to change it's height.
    func resizeTextView(textView: UITextView) {
        let sizeThatFitsTextView = textView.sizeThatFits(CGSize(width: textView.frame.width, height: CGFloat(MAXFLOAT)))
        print("texview. \(sizeThatFitsTextView)")

        let changedHeight = sizeThatFitsTextView.height
        textViewBackgroundViewHeightConstraint.constant = changedHeight
        bottomOutletHeight.constant = (changedHeight + 10)
        self.view.layoutIfNeeded()
        print("textview.after \(changedHeight)")
        if keyboardHeight == 0
        {
            self.tableViewBottomContraint.constant = bottomViewOutlet.frame.height
        }
        else
        {
            if hasTopNotch{
                    self.tableViewBottomContraint.constant = (bottomViewOutlet.frame.height + (keyboardHeight - 30))
            }
            else
            {
        self.tableViewBottomContraint.constant = (bottomViewOutlet.frame.height + keyboardHeight)
            }
        }

    }

    
}


///////////// Tableview Scroller bottom to top extension
extension UITableView {
    public func reloadData(_ completion: @escaping ()->()) {
        UIView.animate(withDuration: 0, animations: {
            self.reloadData()
        }, completion:{ _ in
            completion()
        })
    }
    func scroll(to: scrollsTo, animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
            let numberOfSections = self.numberOfSections
            let numberOfRows = self.numberOfRows(inSection: numberOfSections-1)
            switch to{
            case .top:
                if numberOfRows > 0 {
                    let indexPath = IndexPath(row: 0, section: 0)
                    self.scrollToRow(at: indexPath, at: .top, animated: animated)
                }
                break
            case .bottom:
                if numberOfRows > 0 {
                    let indexPath = IndexPath(row: numberOfRows-1, section: (numberOfSections-1))
                    self.scrollToRow(at: indexPath, at: .bottom, animated: animated)
                }
                break
            }
        }
    }
    
    enum scrollsTo {
        case top,bottom
    }
}



