//
//  ConversationViewController.swift
//  KeywoImage
//
//  Created by IOS Developer6 on 27/03/18.
//  Copyright © 2018 IOS Developer. All rights reserved.
//

import UIKit
import Segmentio
import DropDown
import Foundation
class ConversationViewController: UIViewController {
    
    var page = 0
    var selectedIndex =  0
    var isShowSearch = Bool()
    
    var searchBar = UISearchBar()
    var rightSearchBarButtonItem: UIBarButtonItem?


    @IBOutlet weak var searchBarHeightOutlet: NSLayoutConstraint!
    @IBOutlet weak var searchBarOutlet: UISearchBar!
        {
        didSet {
            //searchBarOutlet.change(textFont: GlobalConstants.Font.avenirBook14)
            
            searchBarOutlet.change(textFont: UIFont(name:"FontAwesome",size:10))
        }
    }
    
    
    @IBOutlet weak var segmentioView: Segmentio!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var scrollViewInContrinerView: UIScrollView!
    @IBOutlet weak var refreshBtn: UIBarButtonItem!
    
   
    let dropDown = DropDown()
    var timer : Timer?

    
    
    fileprivate lazy var viewControllers: [UIViewController] = {
        return self.preparedViewControllers()
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
      //  searchBar.delegate = self
        
        // Do any additional setup after loading the view.
    }
   
    
    /// api for chat
//    func getChatApi() {
//
//        if (Utility_Swift.isInternetConnected(isShowPopup: true)) {
//
//            let dictParameters: NSMutableDictionary = ["email":Utility_Swift.getEmail(),
//                                                       "user_id":Utility_Swift.getUserId(),
//                                                       "public_key":Utility_Swift.getPublicKey()
//            ]
//
//            let stringDataToGenerateSignature = "email=\(Utility_Swift.getEmail())" + "&public_key=\(Utility_Swift.getPublicKey())"
//
//            APIManagerClass.sharedManagerClass.hitAPIWithURL(apiURL: BASE_URL + GET_CHAT, methodType: .post, dictionaryParameters: dictParameters, isNew: false , isShowProgress: true, viewCurrent: self.view, completionHandlerSuccess: { (responseInJSON) in
//
//                print(responseInJSON)
//                if let tempResponseDict = responseInJSON as? NSDictionary {
//                    print("Get All Data")
//
//                }
//            }, completionHandlerFailure: { (error) in
//                print(error?.localizedDescription as Any)
//            })
//        }
//    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        setupScrollView()
//
//        SegmentioBuilder.buildSegmentioView(
//            segmentioContent: self.segmentioContentSegmentioItem(),
//            segmentioView: self.segmentioView,
//            segmentioStyle: SegmentioStyle.onlyLabel)
//
//        segmentioView.selectedSegmentioIndex = selectedSegmentioIndex()
//
//        segmentioView.valueDidChange = { [weak self] _, segmentIndex in
//            if let scrollViewWidth = self?.scrollViewInContrinerView.frame.width {
//                let contentOffsetX = scrollViewWidth * CGFloat(segmentIndex)
//                self?.scrollViewInContrinerView.setContentOffset(
//                    CGPoint(x: contentOffsetX, y: 0),
//                    animated: true
//                )
//
//                self!.selectedIndex = segmentIndex
//                print("segmentClick = \(contentOffsetX)")
//                print("segmentClick = \(scrollViewWidth)")
//                self?.page = Int(contentOffsetX/scrollViewWidth)
//                switch self?.page
//                {
//                case 0:
//                    NotificationCenter.default.post(name: NSNotification.Name(rawValue:"Chats"), object:self?.searchBarOutlet.text ?? "")
//
//                case 1:
//                    NotificationCenter.default.post(name: NSNotification.Name(rawValue:"Following"), object:self?.searchBarOutlet.text ?? "")
//
//                default:
//                    break
//                }
//
//            }
//        }
//
//        //////////Clear the background of search Bar
//        let image = UIImage()
//        searchBarOutlet.setBackgroundImage(image, for: .any, barMetrics: .default)
//        searchBarOutlet.scopeBarBackgroundImage = image
//        //////////Clear the background of search Bar
//
//        for subView in searchBarOutlet.subviews  {
//            for subsubView in subView.subviews  {
//                if let textField = subsubView as? UITextField {
//                    var bounds: CGRect
//                    bounds = textField.frame
//                    bounds.size.height = 10 //(set height whatever you want)
//                    textField.bounds = bounds
//                    textField.borderStyle = UITextField.BorderStyle.roundedRect
//                    //                    textField.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
//                    textField.backgroundColor = UIColor.blue
//                    //                    textField.font = UIFont.systemFontOfSize(20)
//
//
//                    textField.leftViewMode = UITextField.ViewMode.never
//                }
//            }
//        }
        


    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        setupScrollView()
        
        SegmentioBuilder.buildSegmentioView(
            segmentioContent: self.segmentioContentSegmentioItem(),
            segmentioView: self.segmentioView,
            segmentioStyle: SegmentioStyle.onlyLabel)
        
        segmentioView.selectedSegmentioIndex = selectedSegmentioIndex()
        
        segmentioView.valueDidChange = { [weak self] _, segmentIndex in
            if let scrollViewWidth = self?.scrollViewInContrinerView.frame.width {
                let contentOffsetX = scrollViewWidth * CGFloat(segmentIndex)
                self?.scrollViewInContrinerView.setContentOffset(
                    CGPoint(x: contentOffsetX, y: 0),
                    animated: true
                )
                
                self!.selectedIndex = segmentIndex
                print("segmentClick = \(contentOffsetX)")
                print("segmentClick = \(scrollViewWidth)")
                self?.page = Int(contentOffsetX/scrollViewWidth)
                switch self?.page
                {
                case 0:
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue:"Chats"), object:self?.searchBarOutlet.text ?? "")
                    
                case 1:
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue:"Following"), object:self?.searchBarOutlet.text ?? "")
                    
                default:
                    break
                }
                
            }
        }
        
        showSearchBar()
        
       // makeTopNavigationSearchbar()
       // activateInitialUISetUp()
        
        
        //////////Clear the background of search Bar
//        let image = UIImage()
//        searchBarOutlet.setBackgroundImage(image, for: .any, barMetrics: .default)
//        searchBarOutlet.scopeBarBackgroundImage = image
        //////////Clear the background of search Bar
        
       
        
        
    }
    
    fileprivate func preparedViewControllers() -> [UIViewController] {
        
        let storyboardObject = UIStoryboard (name :"ChatStoryboard", bundle:nil)
        
        let viewControllerChats = storyboardObject.instantiateViewController(withIdentifier: "ChatsViewController") as! ChatsViewController
        let viewControllerFollowers = storyboardObject.instantiateViewController(withIdentifier: "FollowersChatViewController") as! FollowersChatViewController
    
        return [
            viewControllerChats,
            viewControllerFollowers

        ]
    }
    
    fileprivate func selectedSegmentioIndex() -> Int {
        return 0
    }
    
    fileprivate func setupScrollView() {
        self.scrollViewInContrinerView.contentSize = CGSize(
            width: UIScreen.main.bounds.width * CGFloat(viewControllers.count),
            height: self.viewContainer.frame.height
        )
        
        for (index, viewController) in viewControllers.enumerated() {
            viewController.view.frame = CGRect(
                x: UIScreen.main.bounds.width * CGFloat(index),
                y: 0,
                width: self.scrollViewInContrinerView.frame.width,
                height: self.scrollViewInContrinerView.frame.height
            )
            addChild(viewController)
            self.scrollViewInContrinerView.addSubview(viewController.view, options: .useAutoresize) // module's extension
            viewController.didMove(toParent: self)
        }
    }
    
    // MARK: - Actions
    
    fileprivate func goToControllerAtIndex(_ index: Int) {
        segmentioView.selectedSegmentioIndex = index
    }
    
    func segmentioContentSegmentioItem() -> [SegmentioItem] {
        return [
            SegmentioItem(title: "Chats", image: nil),
            SegmentioItem(title: "Followings", image: nil),
        ]
    }
    
    
    @IBAction func optionButton(_ sender: UIBarButtonItem) {
        
//        let dropDownPopular = DropDown()
//        dropDownPopular.anchorView = sender
//        dropDownPopular.bottomOffset = CGPoint.init(x: -50, y: 40)
//        dropDownPopular.dataSource = ["Refresh"]
//        dropDownPopular.textColor = UIColor.black
//        dropDownPopular.selectionAction = { (index: Int, item: String) in
//            //sender.setTitle(item,for: .normal)
//        }
//        dropDownPopular.show()
        
        isShowSearch = true
        showSearchBar()
       // showSearchBarNew()


        
    }
    
    func showSearchBar()
    {
       if isShowSearch == true
       {
        UIView.animate(withDuration: 0.35, animations: {
            self.searchBarHeightOutlet.constant = 40
        }, completion: { finished in
            self.searchBarOutlet.becomeFirstResponder()
        })
        
        
        for subView in searchBarOutlet.subviews  {
            for subsubView in subView.subviews  {
                if let textField = subsubView as? UITextField {
                    var bounds: CGRect
                    bounds = textField.frame
                    bounds.size.height = 35 //(set height whatever you want)
                    textField.bounds = bounds
                    textField.borderStyle = UITextField.BorderStyle.roundedRect
                    //                    textField.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
                    textField.backgroundColor = UIColor.clear
                    //                    textField.font = UIFont.systemFontOfSize(20)
                    
                    textField.leftViewMode = UITextField.ViewMode.never
                }
            }
        }
        
        //////////Clear the background of search Bar
                let image = UIImage()
                searchBarOutlet.setBackgroundImage(image, for: .any, barMetrics: .default)
                searchBarOutlet.scopeBarBackgroundImage = image
        //////////Clear the background of search Bar
        
        

        }
       else{
        
        UIView.animate(withDuration: 0.55, animations: {
            self.searchBarHeightOutlet.constant = 0
        }, completion: { finished in
           // self.searchBarOutlet.becomeFirstResponder()
        })        }
    }
}

extension ConversationViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentPage = floor(scrollView.contentOffset.x / scrollView.frame.width)
        self.segmentioView.selectedSegmentioIndex = Int(currentPage)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.contentSize = CGSize(width: scrollView.contentSize.width, height: 0)
    }
    
}

extension ConversationViewController: UISearchBarDelegate
{
    //Making secondary Searchbar
    func makeTopNavigationSearchbar()
    {
        //        let logoImage = UIImage(named: "password")!
        //        logoImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: logoImage.size.width, height: logoImage.size.height))
        //        logoImageView.image = logoImage
        //        barButton.customView?.addSubview(logoImageView)
        
        searchBar.delegate = self
        searchBar.searchBarStyle = UISearchBar.Style.minimal
        rightSearchBarButtonItem = navigationItem.leftBarButtonItem
        rightSearchBarButtonItem?.tintColor =  UIColor.black
        
    }
    func activateInitialUISetUp()
    {
//        self.navigationController?.isNavigationBarHidden =  false
//        self.navigationController?.navigationBar.barStyle = UIBarStyle.blackOpaque
//        self.navigationController?.navigationBar.isTranslucent =  true
        //self.navigationController?.navigationBar.backgroundColor =  UIColor.red
        
        //Nav Bar Searchbar
        searchBar.delegate = self
        searchBar.placeholder = "Search by name"
        ///  barButton.action = "showSearchBar"
        // self.barButton.action =  #selector(showSearchBar(sender:))
        refreshBtn.target = self
        
        //searchbar Text Color
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = UIColor.black
        
        
        //Nav Bar Title
        self.title = "Conversations"
    }
    
    func showSearchBarNew() {
        searchBar.isHidden =  false
        searchBar.alpha = 0
        navigationItem.titleView = searchBar
        navigationItem.setLeftBarButton(nil, animated: true)
        // navigationItem.setRightBarButtonItem(nil, animated: true)
        
        UIView.animate(withDuration: 0.5, animations: {
            self.searchBar.alpha = 1
        }, completion: { finished in
            self.searchBar.becomeFirstResponder()
        })
    }
    func hideSearchBar()
    {
        hideSearchBarAndMakeUIChanges()
        self.refreshBtn.isEnabled = true
    }
    
    func hideSearchBarAndMakeUIChanges ()
    {
        searchBar.isHidden =  true
        
        //Adding secondary uibarbuttons to the nav bar and revoke its methods
        navigationItem.setLeftBarButton(rightSearchBarButtonItem, animated: true)
        //    navigationItem.setRightBarButtonItem(rightSearchBarButtonItem, animated: true)
        
        //        leftSearchBarButtonItem?.title = "Menu"
        //        leftSearchBarButtonItem?.target = self.revealViewController()
        //        leftSearchBarButtonItem?.action = "revealToggle:"
        
        rightSearchBarButtonItem?.title = "Search by name"
        rightSearchBarButtonItem?.target = self
        //   rightSearchBarButtonItem?.action = "showSearchBar"
        
        
        //Adding Title Label
        let navigationTitlelabel = UILabel(frame: CGRect(origin: .zero, size: CGSize(width: 100, height: 100)))
        // navigationTitlelabel.center = CGPoint(160, 284)
        //   let navigationTitlelabel = UILabel(frame: CGRectMake(0, 0, 200, 21))
        navigationTitlelabel.center = CGPoint(x: 160, y: 284)
        navigationTitlelabel.textAlignment = NSTextAlignment.center
        navigationTitlelabel.textColor  = UIColor.white
        navigationTitlelabel.text = "Conversations"
        self.navigationController!.navigationBar.topItem!.titleView = navigationTitlelabel
        
    }


    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if isShowSearch == true{
            
            if searchBarOutlet.text == ""
            {
                isShowSearch = false
                showSearchBar()
                searchBarOutlet.resignFirstResponder()
            }
        }
        
        
        if timer == nil || (timer?.isValid == false)
        {
            timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(reloadSearch(timer:)), userInfo: nil, repeats: false)
        }
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        isShowSearch = false
        showSearchBar()
      //  hideSearchBar()

    }
//    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
//        searchBar.setShowsCancelButton(false, animated: true)
//    }
//
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)  {
        
        //hideSearchBar()
        searchBar.resignFirstResponder()
    }
    
    
    
//    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
//        // self.navigationController?.navigationBar.isHidden = true
//        var r = self.view.frame
//        r.origin.y = -44
//        r.size.height += 44
//
//        self.view.frame = r
//        searchBar.setShowsCancelButton(true, animated: true)
//        self.refreshBtn.isEnabled = false
//
//    }
    
    @objc func reloadSearch(timer: Timer!) {
        timer?.invalidate()
        switch self.page
        {
        case 0:
            NotificationCenter.default.post(name: NSNotification.Name(rawValue:"Chats"), object:self.searchBarOutlet.text ?? "")
            
        case 1:
            NotificationCenter.default.post(name: NSNotification.Name(rawValue:"Following"), object:self.searchBarOutlet.text ?? "")
            
        default:
            break
        }
    }
    
}

