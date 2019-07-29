//
//  EntryDB.swift
//  WeeklyApp
//
//  Created by Mike on 3/11/19.
//  Copyright © 2019 rdm. All rights reserved.
//

import Foundation
import SQLite3

public class EntryDB{
    var selectStatement: OpaquePointer?
    var db: OpaquePointer?
    
    struct EventObject{
        let id: Int
        let name: String
        let time: String
        let day: String
        let status: String
    }
    
    struct MainListStruct{
        static var MainList: Array<EventObject> = []
    }
    
    func ConfirmDB(){
        let fileUrl = try! //try is an exception incase something goes wrong
            FileManager.default.url(for: .documentDirectory, //creates file for document directory
                in: .userDomainMask, appropriateFor: nil,create: //creates the file inside user domain mask, create true creates a new file every time, false makes it only if it doesn't already exist
                false).appendingPathComponent("TaskDatabase.sqlite") //the actual file name
        
        if sqlite3_open(fileUrl.path, &db) != SQLITE_OK{    //
            //print("Error opening DB file")
        }
        
        let createTableQuery = "CREATE TABLE IF NOT EXISTS Tasks (id INTEGER PRIMARY KEY AUTOINCREMENT, TaskName TEXT NOT NULL, TaskTime TEXT NOT NULL, TaskDay TEXT NOT NULL, TaskStatus BOOL NOT NULL)"
        
        if sqlite3_exec(db, createTableQuery,nil,nil,nil) != SQLITE_OK{
            //print("Error creating table")
        } else {
            //print("Everything is ok")
        }

        
    }
    
    func ConfirmButtonDB(arg taskName:String, arg taskTime:String, arg taskDay:String){
        ConfirmDB() //opens the DB and creates the table if it doesn't already exist
        var stmt: OpaquePointer?
        
        let insertQuery = "INSERT INTO Tasks(TaskName, TaskTime, TaskDay, TaskStatus) VALUES (?,?,?,0)"
        
        if sqlite3_prepare(db, insertQuery, -1, &stmt, nil) != SQLITE_OK{
            //print("Error running query")
        } else {
            //print("All is well")
        }
        
        if sqlite3_bind_text(stmt, 1, (taskName as NSString).utf8String, -1, nil) != SQLITE_OK{
            //print("Error binding name")
        }
        if sqlite3_bind_text(stmt, 2, (taskTime as NSString).utf8String, -1, nil) != SQLITE_OK{
            //print("Error binding time")
        }
        if sqlite3_bind_text(stmt, 3, (taskDay as NSString).utf8String, -1, nil) != SQLITE_OK{
            //print("Error binding Day")
        }
        
        if sqlite3_step(stmt) == SQLITE_DONE{
            //print("SQlite ran")
        }
        ReturnFullTable()
    } //end of ConfirmButtonDB func
    
    //beginnning of delete row
    func deleteRow(arg rowNum:Int){
        //var selectStatement: OpaquePointer?
        var db: OpaquePointer?
        //var list: Array<EventObject> = []
        
        let fileUrl = try! //try is an exception incase something goes wrong
            FileManager.default.url(for: .documentDirectory, //creates file for document directory
                in: .userDomainMask, appropriateFor: nil,create: //creates the file inside user domain mask, create true creates a new file every time, false makes it only if it doesn't already exist
                false).appendingPathComponent("TaskDatabase.sqlite") //the actual file name
        
        if sqlite3_open(fileUrl.path, &db) != SQLITE_OK{    //
            //print("Error opening DB")
        }
        
        let updateQuery = "DELETE FROM Tasks WHERE ID = \(EntryDB.MainListStruct.MainList[rowNum].id)"
        
        if sqlite3_exec(db, updateQuery,nil,nil,nil) != SQLITE_OK{
            //print("Error updating table")
        } else {
            //print("Update went well")
        }
        
        ReturnFullTable()
    }
    
    //beginning of updateTable
    func updateTableCheckboxPressed(arg entryID:Int){
        let DBHelper2 = EntryDB()
        EntryDB.ReturnFullTable(DBHelper2)()
        let entryNum = entryID
        
            //var selectStatement: OpaquePointer?
            var db: OpaquePointer?
            //var list: Array<EventObject> = []
            
            let fileUrl = try! //try is an exception incase something goes wrong
                FileManager.default.url(for: .documentDirectory, //creates file for document directory
                    in: .userDomainMask, appropriateFor: nil,create: //creates the file inside user domain mask, create true creates a new file every time, false makes it only if it doesn't already exist
                    false).appendingPathComponent("TaskDatabase.sqlite") //the actual file name
            
            if sqlite3_open(fileUrl.path, &db) != SQLITE_OK{    //
                //print("Error opening DB")
            }
            
            var updateQuery = ""
            if(Int(EntryDB.MainListStruct.MainList[entryNum].status) == 0){
                updateQuery = "UPDATE Tasks SET TaskStatus = 1 WHERE ID = \(EntryDB.MainListStruct.MainList[entryNum].id)"
            } else {
                updateQuery = "UPDATE Tasks SET TaskStatus = 0 WHERE ID = \(EntryDB.MainListStruct.MainList[entryNum].id)"
            }
            
                if sqlite3_exec(db, updateQuery,nil,nil,nil) != SQLITE_OK{
                    //print("Error updating table")
                } else {
                    //print("Update went well")
                }

            ReturnFullTable()
 
        
    }

    
    //beginning of updateTable
    func updateRestartCheck(arg entryID:Int){
        let DBHelper2 = EntryDB()
        EntryDB.ReturnFullTable(DBHelper2)()
        var entryNum = entryID+1
        
        
        
        
        for index in 0 ... EntryDB.MainListStruct.MainList.count-1{
            if EntryDB.MainListStruct.MainList[index].id == entryNum {
                entryNum = index
                break
            }
            
        }
        
        //var selectStatement: OpaquePointer?
        var db: OpaquePointer?
        //var list: Array<EventObject> = []
        
        let fileUrl = try! //try is an exception incase something goes wrong
            FileManager.default.url(for: .documentDirectory, //creates file for document directory
                in: .userDomainMask, appropriateFor: nil,create: //creates the file inside user domain mask, create true creates a new file every time, false makes it only if it doesn't already exist
                false).appendingPathComponent("TaskDatabase.sqlite") //the actual file name
        
        if sqlite3_open(fileUrl.path, &db) != SQLITE_OK{    //
            //print("Error opening DB")
        }
        
        var updateQuery = ""
        if(Int(EntryDB.MainListStruct.MainList[entryNum].status) == 0){
            updateQuery = "UPDATE Tasks SET TaskStatus = 1 WHERE ID = \(EntryDB.MainListStruct.MainList[entryNum].id)"
        } else {
            updateQuery = "UPDATE Tasks SET TaskStatus = 0 WHERE ID = \(EntryDB.MainListStruct.MainList[entryNum].id)"
        }
        
        if sqlite3_exec(db, updateQuery,nil,nil,nil) != SQLITE_OK{
            //print("Error updating table")
        } else {
            //print("Update went well")
        }
        
        ReturnFullTable()
        
        
    }
    
    //beginning of return full table
    func ReturnFullTable(){
        var selectStatement: OpaquePointer?
        var db: OpaquePointer?
        var list: Array<EventObject> = []
        
        let fileUrl = try! //try is an exception incase something goes wrong
            FileManager.default.url(for: .documentDirectory, //creates file for document directory
                in: .userDomainMask, appropriateFor: nil,create: //creates the file inside user domain mask, create true creates a new file every time, false makes it only if it doesn't already exist
                false).appendingPathComponent("TaskDatabase.sqlite") //the actual file name
        
        if sqlite3_open(fileUrl.path, &db) != SQLITE_OK{    //
            //print("Error opening DB")
        }
        
        let selectSql = "select * from Tasks"
        if sqlite3_prepare_v2(db, selectSql, -1, &selectStatement, nil) == SQLITE_OK{
            while sqlite3_step(selectStatement) == SQLITE_ROW{
                let rowID = sqlite3_column_int(selectStatement,0)
                let name = sqlite3_column_text (selectStatement,1)
                let time = sqlite3_column_text(selectStatement,2)
                let day = sqlite3_column_text(selectStatement,3)
                let status = sqlite3_column_text(selectStatement, 4)
                
                let nameString = String(cString: name!)
                let timeString = String(cString: time!)
                let dayString = String(cString: day!)
                let status2 = String(cString: status!)
                
                //print("\(rowID) \(nameString) \(timeString) \(dayString) \(status2)")
                let elm = EventObject(id: Int(rowID), name: nameString, time: timeString, day: dayString, status: status2)
                list.append(elm)
            }
        } //end of if statement for printing table
        
        //this block prints out the list
        /*
        if(sqlite3_prepare_v2(db, selectSql, -1, &selectStatement, nil) == SQLITE_OK){
            for index in 0...list.count-1{
                print(list[index])
            }
        }*/
        //end of if statement to print out the list
        
        MainListStruct.MainList = list

    }
    // end of return full table
    
    
    
}//End of EntryDB class
