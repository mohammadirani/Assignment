
//
//  FollowersChatViewController.swift
//  KeywoImage
//
//  Created by IOS Developer6 on 27/03/18.
//  Copyright © 2018 IOS Developer. All rights reserved.
//

import UIKit

class FollowersChatViewController: UIViewController {
    
    @IBOutlet weak var followersTableView: UITableView!
    
    var page = Int()
    var followersDic : FollowersModel!
    var targetUserId =  String()
    var searchString = String()
    
    private let refreshControl = UIRefreshControl()
    var isRefresh = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNibForTableViewCell()
        page = 1
        searchString = ""
        followerListApi(search: searchString)
        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(self, selector:#selector(FollowersChatViewController.methodUIAppearanceChangedFollow(notification:)) , name: NSNotification.Name(rawValue:"Following"), object:nil)
        
        
        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: UIControl.Event.valueChanged)
        followersTableView.addSubview(refreshControl)
    }
    
    @objc private func refresh(_ sender: Any) {
        
        isRefresh = true
        followersDic =  nil
        page = 1
        searchString = ""
        followerListApi(search: searchString)
    }
    
    @objc func methodUIAppearanceChangedFollow(notification: NSNotification) {
        
        if (notification.object != nil)  {
            
            followersDic =  nil
            page = 1
            searchString = notification.object as! String
            followerListApi(search:searchString)
            
            
        }
    }
    
    
    
    func followerListApi(search:String)  {
        
        if (Utility_Swift.isInternetConnected(isShowPopup: true)) {
            
            if targetUserId == "" {targetUserId =  Utility_Swift.getUserId() }
            
            
            //            let dictParameters: NSMutableDictionary = ["user_id": Utility_Swift.getUserId(),
            //                                                       "target_user_id": targetUserId,
            //                                                       "search":search,
            //                                                       "offset":page]
            var url = ""
            if search == ""
            {
                url = BASE_URL + GET_FOLLOWINGS + "\(targetUserId)" + "/" + "\(page)"
            }
            else
            {
                url = BASE_URL + GET_FOLLOWINGS + "\(targetUserId)" + "/" + "\(page)" + "/" + search
            }
            
            APIManagerClass.sharedManagerClass.hitAPIWithURL(apiURL: url, methodType: .get, dictionaryParameters: NSMutableDictionary(), isNew: false , isShowProgress: true, viewCurrent: self.view, completionHandlerSuccess: { (responseInJSON) in
                
                print(responseInJSON)
                
                if let tempResponseDict = responseInJSON as? [String:Any] {
                    
                    if self.followersDic != nil && self.followersDic.list != nil && self.page == 1
                    {
                        self.self.followersDic.list.removeAll()
                    }
                    
                    let feedData = FollowersModel(fromDictionary: (tempResponseDict["message"] as? [String : Any] ?? [String : Any]()))
                    print(feedData)
                    
                    if (self.followersDic != nil) {
                        self.followersDic.list.append(contentsOf: feedData.list)
                    }
                    else {
                        self.followersDic = feedData
                    }
                    
                    if feedData.list.count < 2
                    {
                        self.isRefresh = true
                    }
                    else
                    {
                        self.isRefresh = false
                        
                    }
                    self.refreshControl.endRefreshing()
                    self.followersTableView.reloadData()
                    
                }
                
            }, completionHandlerFailure: { (error) in
                print(error?.localizedDescription as Any)
            })
        }
        
        
    }
    
    
}

extension FollowersChatViewController : UITableViewDataSource,UITableViewDelegate{
    
    
    func registerNibForTableViewCell() {
        
        followersTableView.register(UINib(nibName: "AddPeopleTableViewCell", bundle: nil), forCellReuseIdentifier: "addpeoplecellreuseidentifier")
        followersTableView.register(UINib(nibName: "NoRecordCell", bundle: nil), forCellReuseIdentifier: "NoRecordCell")
        
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (followersDic != nil) {
            return followersDic.list.count
        }
        else {return 1}
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (followersDic != nil){
            tableView.separatorColor = UIColor.clear
            let cell = tableView.dequeueReusableCell(withIdentifier: "addpeoplecellreuseidentifier", for: indexPath) as! AddPeopleTableViewCell
            
            cell.otherProfileButton.isHidden = true
            cell.selectionStyle = .none
            cell.userImageView.layer.cornerRadius = cell.userImageView.frame.size.width/2
            cell.userImageView.layer.borderWidth = 1.0
            cell.userImageView.layer.borderColor = UIColor.black.cgColor
            
            let tempDataDict = followersDic.list[indexPath.row]
            cell.userNameLabel.text = tempDataDict.firstName + " " + tempDataDict.lastName
            cell.handleLabel.text = "@" + tempDataDict.accountHandle
            cell.handleLabel.font = UIFont.exampleRobotoRegular(ofSize: UILabel.getFontSize(size: 12, view: self.view))
            cell.userImageView.layer.cornerRadius = cell.userImageView.frame.size.width/2
            cell.userImageView.layer.borderWidth = 1.0
            cell.userImageView.layer.borderColor = UIColor.black.cgColor
            
            cell.FollowUnfollowButton.isHidden = true
            
            if tempDataDict.isVerify == 1{
                cell.verifyUser.isHidden = false
            }
            else{
                cell.verifyUser.isHidden = true
            }
            
            
//            if Utility_Swift.getUserId() == tempDataDict.userId {
//                
//                cell.FollowUnfollowButton.isHidden = true
//                
//            }else{
//                
//                cell.FollowUnfollowButton.isHidden = false
//            }
            
             cell.userImageView.pin_updateWithProgress = true
        cell.userImageView.pin_setImage(from: URL(string: tempDataDict.image), placeholderImage: UIImage(named: "ProfileDefault.png"))
            cell.userImageView.image = Utility_Swift.cropToBounds(image:cell.userImageView.image!, width: Double(cell.userImageView.frame.size.width), height: Double(cell.userImageView.frame.size.height))
            
//            cell.callBackOnButton = { (viewControllerToNavigate) in
//                
//                print(viewControllerToNavigate)
//                
//                if viewControllerToNavigate is AccountViewController {
//                    //let ClickedData = self.feedArray[indexPath.section-1]
//                    let vc = viewControllerToNavigate as! AccountViewController
//                    vc.isFrom = "other"
//                    vc.targetUserId = tempDataDict.userId
//                    // vc.postId = ClickedData.postId
//                    self.navigationController?.pushViewController(vc, animated: true)
//                }
//                
//            }
            
            return cell
        }
        else{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "NoRecordCell", for: indexPath) as! NoRecordCell
            
            return cell
        }
    }
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//
//        if followersDic != nil{
//            if indexPath.row == followersDic.list.count - 4 { // last cell
//                if followersDic.totalPages != page { // more items to fetch
//                    page += 1
//                    followerListApi(search:searchString) // increment `fromIndex` by 20 before server call
//                }
//            }
//        }
//    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        // UITableView only moves in one direction, y axis
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        if isRefresh == false
        {
            // Change 10.0 to adjust the distance from bottom
            if maximumOffset - currentOffset <= 10.0 {
                page += 1
                followerListApi(search:searchString) // increment `fromIndex` by 20 before server call
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let singleUserData = followersDic.list[indexPath.row]
        
        let viewControllerObject = UIStoryboard (name :"ChatStoryboard", bundle:nil).instantiateViewController(withIdentifier: "OneToOneChatViewController") as! OneToOneChatViewController
        
        viewControllerObject.userID = singleUserData.userId
        viewControllerObject.recUserName = singleUserData.firstName + singleUserData.lastName
        viewControllerObject.recAccountHandle = singleUserData.accountHandle
        viewControllerObject.recUserImage = singleUserData.image
        
        let navController = UINavigationController(rootViewController: viewControllerObject) // Creating a navigation controller with VC1 at the root of the navigation stack.
        self.present(navController, animated:true, completion: nil)
    }
}
