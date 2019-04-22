//
//  ViewController.swift
//  WeeklyApp
//
//  Created by M on 3/5/19.
//  Copyright © 2019 rdm. All rights reserved.
//

import UIKit
import SQLite3
import UserNotifications

class MainScreen: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var MainTable: UITableView!
    
    let DBHelper = EntryDB()
    
    var timer = Timer()
        
    //code for + button, swaps to time selection screen
    @IBAction func SwapToTime(_ sender: Any) {
        self.performSegue(withIdentifier: "MainToTime", sender: self)
    }
    
    //code for the checkbox whenever it is clicked
    @IBAction func checkBoxPressed(_ sender: UIButton) {
        let buttonTag = sender.tag
        DBHelper.updateTableCheckboxPressed(arg: buttonTag)
        self.MainTable.reloadData()
    }
    

    //code for the read table button
    @IBAction func testDB(_ sender: Any) {
        EntryDB.ReturnFullTable(DBHelper)()
        print("Testing read table button")
        
        if(EntryDB.MainListStruct.MainList.count != 0){
            print(EntryDB.MainListStruct.MainList.count)
            print(EntryDB.MainListStruct.MainList[0].name)
        } else {
            print("Global variable is empty")
        }
    }
    
    //code for the delete table button
    @IBAction func deleteDB(_ sender: Any) {
        var db: OpaquePointer?
        let fileUrl = try! //try is an exception incase something goes wrong
            FileManager.default.url(for: .documentDirectory, //creates file for document directory
                in: .userDomainMask, appropriateFor: nil,create: //creates the file inside user domain mask, create true creates a new file every time, false makes it only if it doesn't already exist
                false).appendingPathComponent("TaskDatabase.sqlite") //the actual file name
        
        if sqlite3_open(fileUrl.path, &db) != SQLITE_OK{
            print("Error opening DB")
        }

        //delete the table
        sqlite3_exec(db, "DROP TABLE Tasks",nil,nil,nil)
        sqlite3_close(db)
        print("Deleted")
        EntryDB.ReturnFullTable(DBHelper)()
        print("New List \(EntryDB.MainListStruct.MainList)")
        self.MainTable.reloadData()
    }
    //end of delete db
    
    //Table view code
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return EntryDB.MainListStruct.MainList.count
    }

    let checkedImage = UIImage(named: "icons8-tick-box-80")! as UIImage
    let uncheckedImage = UIImage(named: "icons8-cancel-80")! as UIImage
    
    //customizing the table view, namely the cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! TableView1
        
        cell.titlecell.text = EntryDB.MainListStruct.MainList[indexPath.row].name
        cell.refcell.text = "Resets every " + EntryDB.MainListStruct.MainList[indexPath.row].day + " at " + EntryDB.MainListStruct.MainList[indexPath.row].time

        if(EntryDB.MainListStruct.MainList[indexPath.row].status == "0"){
            cell.switchButton.setImage(uncheckedImage, for: UIControl.State.normal)
        } else {
            cell.switchButton.setImage(checkedImage, for: UIControl.State.normal)
        }

        cell.switchButton.centerYAnchor.constraint(equalTo: cell.cellView.centerYAnchor).isActive = true
        cell.switchButton.tag = indexPath.row;
        
        //for stretching the dividers
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        return cell
    }
    //end of table view code
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        EntryDB.ReturnFullTable(DBHelper)()
        self.MainTable.reloadData()
        
        //MainTable.rowHeight = UITableView.automaticDimension
        //MainTable.estimatedRowHeight = 100
        
        //sets timer with timeInterval in seconds
        _ = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(MainScreen.repeatingTimeCheck), userInfo: nil, repeats: true)
        
        
    }
    
    @objc func repeatingTimeCheck()
    {
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        let day = calendar.component(.weekday, from: date)
        
        //print(hour, " " , minutes, " " , seconds, "  " , day)
        //1 is sunday, 7 is saturday
        //time is 24 hour format
        //this type of timer does NOT run in the background even if the app isn't fully closed
        

        
        if(EntryDB.MainListStruct.MainList.count > 0){
            for index in 0...EntryDB.MainListStruct.MainList.count-1{
                
                let stringDate = EntryDB.MainListStruct.MainList[index].time
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "hh:mm a"
                let date2 = dateFormatter.date(from: stringDate)!
                let calendar2 = Calendar.current
                let hour2 = calendar2.component(.hour, from: date2)
                let minute2 = calendar2.component(.minute, from: date2)



                if(EntryDB.MainListStruct.MainList[index].status == "1" && hour == hour2 && minutes == minute2){
                    print("TAG BING BING BING")
                    DBHelper.updateTableCheckboxPressed(arg: EntryDB.MainListStruct.MainList[index].id-1)
                    self.MainTable.reloadData()
                    print("TAG ",EntryDB.MainListStruct.MainList[index].status)
                    
                }
                
            }
        }
        
    } // end of repeatingTimeCheck
    
}
