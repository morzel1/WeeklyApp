//
//  TimeSet.swift
//  WeeklyApp
//
//  Created by Mike on 3/5/19.
//  Copyright © 2019 rdm. All rights reserved.
//

import UIKit
import Foundation

class TimeSet: UIViewController {

    @IBAction func BackToMain(_ sender: Any) {
        self.performSegue(withIdentifier: "TimeToMain", sender: self)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    

    
}
