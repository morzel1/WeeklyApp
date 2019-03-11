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
    
    func ConfirmDB(){
        let fileUrl = try! //try is an exception incase something goes wrong
            FileManager.default.url(for: .documentDirectory, //creates file for document directory
                in: .userDomainMask, appropriateFor: nil,create: //creates the file inside user domain mask, create true creates a new file every time, false makes it only if it doesn't already exist
                false).appendingPathComponent("TaskDatabase.sqlite") //the actual file name
        
        if sqlite3_open(fileUrl.path, &db) != SQLITE_OK{    //
            print("Error opening DB file")
        }
        
        let createTableQuery = "CREATE TABLE IF NOT EXISTS Tasks (id INTEGER PRIMARY KEY AUTOINCREMENT, TaskName TEXT NOT NULL, TaskTime TEXT NOT NULL, TaskDay TEXT NOT NULL, TaskStatus BOOL NOT NULL)"
        
        if sqlite3_exec(db, createTableQuery,nil,nil,nil) != SQLITE_OK{
            print("Error creating table")
        } else {
            print("Everything is ok")
        }

        
    }
    
    func ConfirmButtonDB(arg taskName:String, arg taskTime:String, arg taskDay:String){
        ConfirmDB() //opens the DB and creates the table if it doesn't already exist
        var stmt: OpaquePointer?
        
        let insertQuery = "INSERT INTO Tasks(TaskName, TaskTime, TaskDay, TaskStatus) VALUES (?,?,?,False)"
        
        if sqlite3_prepare(db, insertQuery, -1, &stmt, nil) != SQLITE_OK{
            print("Error running query")
        } else {
            print("All is well")
        }
        
        if sqlite3_bind_text(stmt, 1, (taskName as NSString).utf8String, -1, nil) != SQLITE_OK{
            print("Error binding name")
        }
        if sqlite3_bind_text(stmt, 2, (taskTime as NSString).utf8String, -1, nil) != SQLITE_OK{
            print("Error binding time")
        }
        if sqlite3_bind_text(stmt, 3, (taskDay as NSString).utf8String, -1, nil) != SQLITE_OK{
            print("Error binding Day")
        }
        
        if sqlite3_step(stmt) == SQLITE_DONE{
            print("SQlite ran")
        }
    } //end of ConfirmButtonDB func
    
    func readTable(){
        var selectStatement: OpaquePointer?
        var db: OpaquePointer?
        
        let fileUrl = try! //try is an exception incase something goes wrong
            FileManager.default.url(for: .documentDirectory, //creates file for document directory
                in: .userDomainMask, appropriateFor: nil,create: //creates the file inside user domain mask, create true creates a new file every time, false makes it only if it doesn't already exist
                false).appendingPathComponent("TaskDatabase.sqlite") //the actual file name
        
        if sqlite3_open(fileUrl.path, &db) != SQLITE_OK{    //
            print("Error opening DB")
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
                
                print("\(rowID) \(nameString) \(timeString) \(dayString) \(status2)")
            }
        }
    }

}//End of EntryDB class
