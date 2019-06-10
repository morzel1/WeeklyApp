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
                print("Notifications permission granted.")
            }
            else {
                print("Notifications permission denied because: \(error?.localizedDescription).")
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
        
        /*
        //save a list of tasks here
        MainScreen.tempListPause.TempListStatus.removeAll()
        MainScreen.tempListPause.TempListIDS.removeAll()
        
        if(EntryDB.MainListStruct.MainList.isEmpty){
        } else {
            for index in 0 ... EntryDB.MainListStruct.MainList.count-1{
                MainScreen.tempListPause.TempListStatus[index] = EntryDB.MainListStruct.MainList[index].status
                
                MainScreen.tempListPause.TempListIDS[index] = EntryDB.MainListStruct.MainList[index].id
            }
            
            print("TAG4 \(MainScreen.tempListPause.TempListStatus)")
            print("TAG4 \(MainScreen.tempListPause.TempListIDS)")
            print("TAG4 ------------------------------------------")
            print("TAG4 \(EntryDB.MainListStruct.MainList)")
            
            print("TAG will resign active")
        }
         */
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        //when i hit home button
        //also activates when i click on another app in multi window view
        //calls this then will terminate when closing the app
        
        //use this to store the start time for the x minute checker
        print("TAG enter background")
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        
        //calls this on transition from background to foreground then become active goes off
        //does NOT activate when freshly opening the app
        print("TAG Inside become active, is empty check \(MainScreen.NotificationArray.array)")
        if(MainScreen.NotificationArray.array.isEmpty){
        }else{
            MainScreen().compareNotifications()
        }

        print("TAG enter foreground")
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        //app turned on
        
        //use this block to do the check if the event was within the past x minutes
        

        MainScreen().deleteTasks()

        print("TAG did become active")

    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
        //use the same code as enter background block to store start values
        print("TAG will terminate")
    }
    
}
