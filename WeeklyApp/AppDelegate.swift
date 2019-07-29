//
//  AppDelegate.swift
//  WeeklyApp
//
//  Created by M on 3/5/19.
//  Copyright © 2019 rdm. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        // Request user's permission to send notifications.
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                //print("Notifications permission granted.")
            }
            else {
                //print("Notifications permission denied because: \(error?.localizedDescription).")
            }
        }
        
        
        return true
    }

    /* flowchart for the phases of an app
     * starting the app:
        active
     * Multi-window mode:
        active -> resign
     * Picking another app from multi-window or pressing home button once:
        active -> resign -> background
     * Reopening app from background:
        background -> foreground -> active
     * Closing an app:
        active -> resign -> background -> terminate
     */
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        
        //happens when i double tap home and go into multi window mode
        //happens before background happens
        //does NOT happen when entering foreground
 
        let date = Date()
        let calendar = Calendar.current
        let day = calendar.component(.weekday, from: date)
        
        var currentDay = ""
        if (day == 1){
            currentDay = "Sunday"
        } else if (day == 2){
            currentDay = "Monday"
        } else if (day == 3){
            currentDay = "Tuesday"
        } else if (day == 4){
            currentDay = "Wednesday"
        } else if (day == 5){
            currentDay = "Thursday"
        } else if (day == 6){
            currentDay = "Friday"
        } else if (day == 7){
            currentDay = "Saturday"
        }
        
        UserDefaults.standard.set(date, forKey: "date")
        UserDefaults.standard.set(currentDay, forKey:"day1")
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        //when i hit home button
        //also activates when i click on another app in multi window view
        //calls this then will terminate when closing the app
        
        //use this to store the start time for the x minute checker
        //print("TAG enter background")
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        
        //calls this on transition from background to foreground then become active goes off
        //does NOT activate when freshly opening the app
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        //app turned on
        
        //use this block to do the check if the event was within the past x currentMinute

        let DBHelper2 = EntryDB()
        EntryDB.ReturnFullTable(DBHelper2)()
        let nilCheck = UserDefaults.standard.string(forKey: "day1")

        if(nilCheck != nil){
            let date = Date()
            let calendar = Calendar.current
            let currentHour = calendar.component(.hour, from: date)
            let currentMinute = calendar.component(.minute, from: date)
            let day = calendar.component(.weekday, from: date)
            
            /*
            var currentDay = ""
            if (day == 1){
                currentDay = "Sunday"
            } else if (day == 2){
                currentDay = "Monday"
            } else if (day == 3){
                currentDay = "Tuesday"
            } else if (day == 4){
                currentDay = "Wednesday"
            } else if (day == 5){
                currentDay = "Thursday"
            } else if (day == 6){
                currentDay = "Friday"
            } else if (day == 7){
                currentDay = "Saturday"
            }
            */
            
            let OldDate = UserDefaults.standard.object(forKey: "date") as! Date
            
            let oldCalendar = Calendar.current
            let oldHour = oldCalendar.component(.hour, from: OldDate)
            let oldMinutes = oldCalendar.component(.minute, from: OldDate)
            let oldDay = oldCalendar.component(.weekday, from: OldDate)
            
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm:ss"
            //let savedDate = formatter.date(from: hourString)!
            
            //Old date comparison variables are hourString and OldDay
            if(EntryDB.MainListStruct.MainList.count > 0){
                for index in 0...EntryDB.MainListStruct.MainList.count-1{
                    var dateComponents = DateComponents()
                    
                    var savedDay = 1
                    if (EntryDB.MainListStruct.MainList[index].day == "Sunday"){
                        savedDay = 1
                    } else if (EntryDB.MainListStruct.MainList[index].day == "Monday"){
                        savedDay = 2
                    } else if (EntryDB.MainListStruct.MainList[index].day == "Tuesday"){
                        savedDay = 3
                    } else if (EntryDB.MainListStruct.MainList[index].day == "Wednesday"){
                        savedDay = 4
                    } else if (EntryDB.MainListStruct.MainList[index].day == "Thursday"){
                        savedDay = 5
                    } else if (EntryDB.MainListStruct.MainList[index].day == "Friday"){
                        savedDay = 6
                    } else if (EntryDB.MainListStruct.MainList[index].day == "Saturday"){
                        savedDay = 7
                    }
                    
                    let stringDate = EntryDB.MainListStruct.MainList[index].time
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "hh:mm a"
                    let date2 = dateFormatter.date(from: stringDate)!
                    let calendar2 = Calendar.current
                    let savedHour = calendar2.component(.hour, from: date2)
                    let savedMinute = calendar2.component(.minute, from: date2)
                    
                    dateComponents.day = savedDay
                    dateComponents.hour = savedHour
                    dateComponents.minute = savedMinute
                    
                    //(oldHour): \(oldMinutes): \(oldSeconds) -> \(oldDay) is the old variables
                    //currentHour, currentMinute, currentSecond, currentDay is string, day is int
                    //savedHour, savedMinute, savedDay is the saved date from the DB

                    
                    //checks if the the app was reopened in the same day of the week then checks if database time is within old and new
                    if(oldDay == savedDay) && (savedDay == day){
                        if(oldHour <= savedHour && savedHour <= currentHour) && (oldHour != currentHour) && (EntryDB.MainListStruct.MainList[index].status == "1"){
                            MainScreen().DBHelper.updateRestartCheck(arg: EntryDB.MainListStruct.MainList[index].id-1)
                        }
                        
                        if(oldHour == currentHour) && (savedHour == currentHour) && (oldMinutes <= savedMinute && savedMinute <= currentMinute && oldMinutes != currentMinute) && (EntryDB.MainListStruct.MainList[index].status == "1"){
                            MainScreen().DBHelper.updateRestartCheck(arg: EntryDB.MainListStruct.MainList[index].id-1)
                        }
                        
                        /*
                        if(oldHour == currentHour) && (savedHour == currentHour) && (oldMinutes == savedMinute && savedMinute == currentMinute) && (currentSecond == 0) && (EntryDB.updateRestartCheck(arg: EntryDB.MainListStruct.MainList[index].id-1)){
                            
                        }*/
                    }
                    
                    //use cases i need to cover: transition from saturday to sunday (7 to 1 in day int)
                    if(oldDay == 7) && (day == 1){
                        if (savedDay == 7) || (savedDay == 1) {
                            if ((oldHour < savedHour) || (savedHour < currentHour)) && (EntryDB.MainListStruct.MainList[index].status == "1"){
                                MainScreen().DBHelper.updateRestartCheck(arg: EntryDB.MainListStruct.MainList[index].id-1)
                            }
                            
                            if (oldHour == savedHour) && (oldMinutes <= savedMinute) && (EntryDB.MainListStruct.MainList[index].status == "1"){
                                MainScreen().DBHelper.updateRestartCheck(arg: EntryDB.MainListStruct.MainList[index].id-1)
                            }
                            
                            if (savedHour == currentHour) && (savedMinute <= currentMinute) && (EntryDB.MainListStruct.MainList[index].status == "1"){
                                MainScreen().DBHelper.updateRestartCheck(arg: EntryDB.MainListStruct.MainList[index].id-1)
                            }
                            
                        }
                    }
                    
                    //check for within a week (1 to 7 in day int)
                    // 1) if the gap between old and new is larger than 1 (ex: monday to wednesday) you can straight up check if Old < S < N
                    // 2) if the gap is 1 day (ex: monday to tuesday) maybe check if New - old = 1 then check the time between old - 24 and 0 - new
                    if(oldDay < savedDay) && (savedDay < day) && (EntryDB.MainListStruct.MainList[index].status == "1"){
                        MainScreen().DBHelper.updateRestartCheck(arg: EntryDB.MainListStruct.MainList[index].id-1)
                    }
                    
                    if (day-oldDay == 1) && (EntryDB.MainListStruct.MainList[index].status == "1"){
                        if ((oldHour < savedHour) || (savedHour < currentHour)) && (EntryDB.MainListStruct.MainList[index].status == "1"){
                            MainScreen().DBHelper.updateRestartCheck(arg: EntryDB.MainListStruct.MainList[index].id-1)
                        }
                        
                        if (oldHour == savedHour) && (oldMinutes <= savedMinute) && (EntryDB.MainListStruct.MainList[index].status == "1"){
                            MainScreen().DBHelper.updateRestartCheck(arg: EntryDB.MainListStruct.MainList[index].id-1)
                        }
                        
                        if (savedHour == currentHour) && (savedMinute <= currentMinute) && (EntryDB.MainListStruct.MainList[index].status == "1"){
                            MainScreen().DBHelper.updateRestartCheck(arg: EntryDB.MainListStruct.MainList[index].id-1)
                        }
                    } // end of checking day-oldDay
                    
                    
                }// end of for loop
            } //end of if check for EntryDB count
        }

    } // end of full function

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.

    }
    

}
