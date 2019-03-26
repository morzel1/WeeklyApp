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
    /*
    struct EventObject{
        let id: Int
        let name: String
        let time: String
        let day: String
        let status: String
    }
    var list: Array<EventObject> = []
    
    struct MainListStruct{
        static var MainList: Array<EventObject> = []
    }
*/
    /* --------------------------------------------------------------------*/
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
    } //end of delete db
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

