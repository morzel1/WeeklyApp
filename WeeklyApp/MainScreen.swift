//
//  ViewController.swift
//  WeeklyApp
//
//  Created by M on 3/5/19.
//  Copyright © 2019 rdm. All rights reserved.
//

import UIKit
import SQLite3

class MainScreen: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var MainTable: UITableView!
    
    let DBHelper = EntryDB()



    @IBAction func SwapToTime(_ sender: Any) {
        self.performSegue(withIdentifier: "MainToTime", sender: self)
    }
    
    /*
 print(MainScreen.MainListStruct.MainList)
*/
    
    @IBAction func testDB(_ sender: Any) {
        /*struct EventObject{
            let id: Int
            let name: String
            let time: String
            let day: String
            let status: String
        }
        var list: Array<EventObject> = []
*/
        EntryDB.ReturnFullTable(DBHelper)()
        print("Testing read table button")
        //print(EntryDB.MainListStruct.MainList)
        if(EntryDB.MainListStruct.MainList.count != 0){
            print(EntryDB.MainListStruct.MainList.count)
            print(EntryDB.MainListStruct.MainList[0].name)
        } else {
            print("Global variable is empty")
        }
    }
    
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
    } //end of delete db
    
    //Table view code
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return EntryDB.MainListStruct.MainList.count
    }

    let checkedImage = UIImage(named: "icons8-tick-box-80")! as UIImage
    let uncheckedImage = UIImage(named: "icons8-tick-box-80")! as UIImage
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! TableView1
        
        cell.titlecell.text = EntryDB.MainListStruct.MainList[indexPath.row].name
        
        cell.refcell.text = "Resets every " + EntryDB.MainListStruct.MainList[indexPath.row].day + " at " + EntryDB.MainListStruct.MainList[indexPath.row].time


        if(EntryDB.MainListStruct.MainList[indexPath.row].status == "0"){
            /*cell.switchButton.setImage(UIImage(named: "ic_check_box_outline_blank"), for: UIControl.State.normal)*/
            cell.switchButton.setImage(uncheckedImage, for: UIControl.State.normal)
        } else {
            //cell.switchButton.setImage(UIImage(named: "ic_check_box"), for: UIControl.State.normal)
            cell.switchButton.setImage(checkedImage, for: UIControl.State.normal)
        }
        //MainTable.rowHeight = UITableView.automaticDimension
        //MainTable.estimatedRowHeight = 100
        //cell.switchButton.centerYAnchor.
        //cell.switchButton.center = cell.center
        cell.switchButton.centerYAnchor.constraint(equalTo: cell.cellView.centerYAnchor).isActive = true

        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        //cell.textbox.text = EntryDB.MainListStruct.MainList[indexPath.row].time
        return cell
    }
    //end of table view code
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        EntryDB.ReturnFullTable(DBHelper)()
        self.MainTable.reloadData()
        MainTable.rowHeight = UITableView.automaticDimension
        //MainTable.estimatedRowHeight = 100
        
        
    }
    
}



