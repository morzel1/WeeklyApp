//
//  ViewController.swift
//  WeeklyApp
//
//  Created by M on 3/5/19.
//  Copyright © 2019 rdm. All rights reserved.
//

import UIKit

class MainScreen: UIViewController {


    @IBAction func SwapToTime(_ sender: Any) {
        self.performSegue(withIdentifier: "MainToTime", sender: self)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

