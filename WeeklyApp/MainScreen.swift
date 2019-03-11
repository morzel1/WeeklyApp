//
//  ViewController.swift
//  WeeklyApp
//
//  Created by M on 3/5/19.
//  Copyright © 2019 rdm. All rights reserved.
//

import UIKit
import SQLite3

class MainScreen: UIViewController {
    let DBHelper = EntryDB()
    @IBAction func SwapToTime(_ sender: Any) {
        self.performSegue(withIdentifier: "MainToTime", sender: self)
    }
    
    
    @IBAction func testDB(_ sender: Any) {
        EntryDB.readTable(DBHelper)()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

