//
//  TestViewController.swift
//  Postgram
//
//  Created by mohammed on 17/09/19.
//  Copyright © 2019 IOS Developer. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class TestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        IQKeyboardManager.sharedManager().enableAutoToolbar = false
        IQKeyboardManager.sharedManager().enable = false

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
