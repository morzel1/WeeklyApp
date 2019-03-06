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
    let timePicker = UIDatePicker()
    
    //Code for the cancel button
    @IBAction func returnToMain(_ sender: Any) {
        self.performSegue(withIdentifier: "TimeToMain", sender: self)
    }
    //End of cancel button
    
    
    
    //Code for time picker field, perhaps make it bigger
    @IBOutlet weak var TimePickView: UITextField!
    func createDatePicker(){
        timePicker.datePickerMode = .time
        //picks which part of datepicker is used
        TimePickView.inputView = timePicker
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(self.doneClicked))
        
        toolbar.setItems([doneButton], animated:true)
        TimePickView.inputAccessoryView = toolbar
        
    }
    
    @objc func doneClicked(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .medium
        
        TimePickView.text = dateFormatter.string(from: timePicker.date)
        self.view.endEditing(true)
    }
    //End of time picker code
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createDatePicker()
        // Do any additional setup after loading the view, typically from a nib.
    }
    

    
}
