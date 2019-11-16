//
//  TableViewViewController.swift
//  assignment
//
//  Created by sachin toskar on 15/11/19.
//  Copyright © 2019 sachin toskar. All rights reserved.
//

import UIKit
import SDWebImage

class TableViewViewController: UIViewController {
    
    var items = [Item]()
    
    @IBOutlet weak var itemTableView: UITableView!
    
    fileprivate func registerCell() {
        itemTableView.register(UINib(nibName: "ItemTableViewCell", bundle: nil), forCellReuseIdentifier :"ItemTableViewCell")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        postAPI()
        registerCell()
        
    }
    
    
    func postAPI() {
        
        let feedjson = UserDefaults.standard.value(forKey: CACHE_KEY) as? Data != nil ?
            UserDefaults.standard.value(forKey: CACHE_KEY) as! Data : Data()
        let feedDictionary = NSKeyedUnarchiver.unarchiveObject(with: feedjson) as? Dictionary<String,Any> ?? Dictionary<String,Any>()
        
        if feedDictionary.values.isEmpty {
            
            let dictParameters: [String:Any] = ["emailId": "fdf@gfdfdf.com"]
            APIManagerClass.sharedManagerClass.hitAPIWithURL(apiURL:BASE_URL, methodType: .post, dictionaryParameters: dictParameters, completionHandlerSuccess: {(responseInJSON) in
                
                print(responseInJSON)
                if let dictionaryResponse = responseInJSON as? NSDictionary {
                    if (dictionaryResponse["statusCode"] as? Int == 200)  {
                        
                        let temp = dictionaryResponse["message"] as! [String:Any]
                        
                        let userData = NSKeyedArchiver.archivedData(withRootObject: dictionaryResponse)
                        UserDefaults.standard.set(userData,forKey: CACHE_KEY)
                        
                        if let itemsArray = temp["items"] as? [[String:Any]]{
                            
                            for dic in itemsArray{
                                let value = Item(fromDictionary: dic)
                                self.items.append(value)
                            }

                            self.itemTableView.reloadData()
                    
                        }
                        
                    }
                    else {
                        if (dictionaryResponse["message"] as? String) != nil {
                            
                            print(dictionaryResponse["message"] as Any)
                            
                        }
                    }
                }
            }, completionHandlerFailure: { (error) in
                print(error?.localizedDescription as Any)
            })
        }
        else{

            let temp = feedDictionary["message"] as! [String:Any]

            if let itemsArray = temp["items"] as? [[String:Any]]{

                for dic in itemsArray{
                    let value = Item(fromDictionary: dic)
                    self.items.append(value)
                }
                self.itemTableView.reloadData()
                UserDefaults.standard.removeObject(forKey: CACHE_KEY)
                self.items.removeAll()
                self.postAPI()
            }
        }
        
    }
}
    
    extension TableViewViewController:UITableViewDelegate,UITableViewDataSource{
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            
            if items.count > 0{
                return items.count
            }else{
                return 0
            }
            
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let singleObj = items[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "ItemTableViewCell", for: indexPath) as! ItemTableViewCell
            
            if let img = singleObj.imageUrl{
                cell.personImgView.sd_setImage(with: URL(string: img), placeholderImage: UIImage(named: "Default"), options: .transformAnimatedImage, progress: nil, completed: nil)
            }
            
            cell.nameLbl.text = singleObj.firstName + " " + singleObj.lastName
            
            if let email = singleObj.emailId {
                cell.emailLbl.text = email
            }
            
            return cell
        }
        
}

