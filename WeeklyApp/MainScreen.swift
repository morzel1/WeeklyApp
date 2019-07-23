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

class MainScreen: UIViewController, UITableViewDelegate, UITableViewDataSource, UNUserNotificationCenterDelegate  {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBOutlet weak var MainTable: UITableView!
    
    var deleteRowIndexPath: NSIndexPath? = nil
    
    
    static var SaveList: Array<String> = []
    static var SaveListIDS: Array<Int> = []
    
    let DBHelper = EntryDB()
    
    var timer = Timer()
    
    struct DataTypes{
        var arrayID: Int
        var NotifID: String
    }
    
    struct DataTypes2{
        var arrayID: Int
        var NotifID: String
    }
    
    static var NotificationArray: Array<DataTypes> = []
    
    /*
    struct NotificationArray{
        static var array: Array<DataTypes> = []
    }
 */

    //code for + button, swaps to time selection screen
    @IBAction func SwapToTime(_ sender: Any) {
        self.performSegue(withIdentifier: "MainToTime", sender: self)
    }
    
    
    //code for the checkbox whenever it is clicked
    @IBAction func checkBoxPressed(_ sender: UIButton) {
        let center = UNUserNotificationCenter.current()
        let buttonTag = sender.tag
        DBHelper.updateTableCheckboxPressed(arg: buttonTag)
        
        //load in MainScreen.NotificaitonArray
        
        if(EntryDB.MainListStruct.MainList[buttonTag].status == "1"){
            //sets alarm when the box gets checked
            scheduleNotification(arg: buttonTag)
        } else if (MainScreen.NotificationArray.isEmpty){
            //Old method, possibly delete
        }else{
            var placeHolder = 0
            //cancel the notification when the box gets unchecked
            for index in 0 ... MainScreen.NotificationArray.count-1{
                if(MainScreen.NotificationArray[index].arrayID == buttonTag){
                    placeHolder = index
                }
            }
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [MainScreen.NotificationArray[placeHolder].NotifID])
            //center.removePendingNotificationRequests(withIdentifiers: [MainScreen.NotificationArray[placeHolder].NotifID])
            MainScreen.NotificationArray.remove(at: placeHolder)
            MainTable.reloadRows(at: MainTable!.indexPathsForVisibleRows!, with: .none)
        }
        
        MainTable.reloadRows(at: MainTable!.indexPathsForVisibleRows!, with: .none)
        //MainTable.reloadData()
    }
    
    //schedules notification when called
    func scheduleNotification(arg entryID:Int) {
        let center = UNUserNotificationCenter.current()
        
        let stringDate = EntryDB.MainListStruct.MainList[entryID].time
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        let date2 = dateFormatter.date(from: stringDate)!
        let calendar2 = Calendar.current
        let hour2 = calendar2.component(.hour, from: date2)
        let minute2 = calendar2.component(.minute, from: date2)
        
        var day2 = 1
        if(EntryDB.MainListStruct.MainList[entryID].day == "Sunday"){
            day2 = 1
        } else if (EntryDB.MainListStruct.MainList[entryID].day == "Monday"){
            day2 = 2
        } else if (EntryDB.MainListStruct.MainList[entryID].day == "Tuesday"){
            day2 = 3
        } else if (EntryDB.MainListStruct.MainList[entryID].day == "Wednesday"){
            day2 = 4
        } else if (EntryDB.MainListStruct.MainList[entryID].day == "Thursday"){
            day2 = 5
        } else if (EntryDB.MainListStruct.MainList[entryID].day == "Friday"){
            day2 = 6
        } else if (EntryDB.MainListStruct.MainList[entryID].day == "Saturday"){
            day2 = 7
        }
        
        if(EntryDB.MainListStruct.MainList[entryID].status == "1"){
            let center = UNUserNotificationCenter.current()
            let content = UNMutableNotificationContent()
            content.title = "Weekly Reset!"
            content.body = "\(EntryDB.MainListStruct.MainList[entryID].name) has reset"
            content.categoryIdentifier = "alarm"
            content.userInfo = ["customData": "fizzbuzz"]
            content.sound = UNNotificationSound.default
            
            var dateComponents = DateComponents()
            dateComponents.hour = hour2
            dateComponents.minute = minute2
            dateComponents.weekday = day2
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)

            let idHold = UUID().uuidString
            
            let request = UNNotificationRequest(identifier: idHold, content: content, trigger: trigger)
            center.add(request)
            
            let elm = DataTypes(arrayID: entryID, NotifID: idHold)
            MainScreen.NotificationArray.append(elm)
            

            //insert MainScreen.NotificationArray saver
            //UserDefaults.standard.set(try? PropertyListEncoder().encode(MainScreen.NotificationArray), forKey: "Save3")
            /*
            var defaults = UserDefaults.standard
            let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: MainScreen.NotificationArray)
            defaults.set(encodedData, forKey: "Save3")
 */
        }
        
        
    }
    
    
    //Table view code
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return EntryDB.MainListStruct.MainList.count
    }

    let checkedImage = UIImage(named: "icons8-cancel-84")! as UIImage
    let uncheckedImage = UIImage(named: "icons8-cancel-81")! as UIImage
    

    
    //customizing the table view, namely the cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.tableFooterView = UIView(frame: .zero)

        
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
    
     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            deleteRowIndexPath = indexPath as NSIndexPath
            confirmDelete(index: indexPath.row)
        }
    }
    

    func confirmDelete(index: Int) {
        let alert = UIAlertController(title: "Delete Task", message: "Are you sure you want to permanently delete: \n \(EntryDB.MainListStruct.MainList[index].name)?", preferredStyle: .actionSheet)
        
        let DeleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: deleteTaskConfirm)
        let CancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: cancelDeleteRow)
        
                alert.addAction(DeleteAction)
                alert.addAction(CancelAction)
        
                // Support display in iPad
                alert.popoverPresentationController?.sourceView = self.view
        //alert.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.size.width / 2.0, y: self.view.bounds.size.height / 2.0, width: 1.0, height: 1.0)
        
        let screenWidth  = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        
        alert.popoverPresentationController?.permittedArrowDirections = .up
        
        alert.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: screenHeight / 4.0, width: 0, height: 0)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func deleteTaskConfirm(alertAction: UIAlertAction!) -> Void{
        if(EntryDB.MainListStruct.MainList[deleteRowIndexPath!.row].status == "1"){
            if(!MainScreen.NotificationArray.isEmpty){
                    var placeHolder = 0
                    //cancel the notification when the box gets unchecked
                    for index in 0 ... MainScreen.NotificationArray.count-1{
                        if(MainScreen.NotificationArray[index].arrayID == deleteRowIndexPath!.row){
                            placeHolder = index
                        }
                    }
                    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [MainScreen.NotificationArray[placeHolder].NotifID])
                    //center.removePendingNotificationRequests(withIdentifiers: [MainScreen.NotificationArray[placeHolder].NotifID])
                    MainScreen.NotificationArray.remove(at: placeHolder)
                    MainTable.reloadData()
                }
        }
        
        DBHelper.deleteRow(arg: deleteRowIndexPath!.row)
        deleteRowIndexPath = nil
        MainTable.reloadData()
    }
    
    func cancelDeleteRow(alertAction: UIAlertAction!){
        deleteRowIndexPath = nil
    }
    //end of table view code
    
    /*
    func compareNotifications(){
        MainScreen.SaveList.removeAll()
        MainScreen.SaveListIDS.removeAll()
        let defaults = UserDefaults.standard
        defaults.set(MainScreen.SaveList, forKey: "Save1")
        defaults.set(MainScreen.SaveListIDS, forKey: "Save2")
        //load in MainScreen.NotificationArray
        print("TAG2 Spot1 \(MainScreen.NotificationArray)")

        
        if(!MainScreen.NotificationArray.isEmpty){
            UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: {requests -> () in
                for request in requests{
                    print("TAG2 Spot2 \(MainScreen.NotificationArray)")
                    for index in 0 ... MainScreen.NotificationArray.count-1{
                        if(MainScreen.NotificationArray[index].NotifID.contains(request.identifier)){
                            MainScreen.SaveList.append(request.identifier)
                            MainScreen.SaveListIDS.append(MainScreen.NotificationArray[index].arrayID)

                        }
                    } //end of notification array loop
                } // end of notification array
                let defaults = UserDefaults.standard
                defaults.set(MainScreen.SaveList, forKey: "Save1")
                defaults.set(MainScreen.SaveListIDS, forKey: "Save2")
            })

        }
 
    }
    
    func deleteTasks(){
        MainScreen.NotificationArray = []
        
        let defaults = UserDefaults.standard
        let myarray1 = defaults.stringArray(forKey: "Save1") ?? [String]()
        let myarray2 = defaults.array(forKey: "Save2") as? [Int] ?? [Int]()
        MainScreen.SaveList = myarray1
        MainScreen.SaveListIDS = myarray2
        
        //if(!MainScreen.SaveList.isEmpty && !MainScreen.SaveListIDS.isEmpty){
            UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: {requests -> () in
                for request in requests{
                    if(MainScreen.SaveList.contains(request.identifier)){
                        let elm = DataTypes(arrayID: MainScreen.SaveListIDS[MainScreen.SaveList.firstIndex(of: request.identifier)!], NotifID: request.identifier)
                        MainScreen.NotificationArray.append(elm)
                    } else {
                   UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [request.identifier])
                    }
                }
                
                //insert MainScreen.NotificationArray saver
            })
        //}
        //EntryDB ID is always 1 higher than the SAVELIST one, add 1 to save list id
        
        if(MainScreen.SaveListIDS.isEmpty && !EntryDB.MainListStruct.MainList.isEmpty){
            if(EntryDB.MainListStruct.MainList[0].status == "1"){
                DBHelper.updateTableCheckboxPressed(arg:                 EntryDB.MainListStruct.MainList[0].id-1)
            }
        }
        
        if(!MainScreen.SaveListIDS.isEmpty && !EntryDB.MainListStruct.MainList.isEmpty){
            //do a check here between the MainScreen.MainList ids to the ids of saveListIDS
            for index in 0 ... EntryDB.MainListStruct.MainList.count-1{
                
                
                for index2 in 0 ... MainScreen.SaveListIDS.count-1{
                    //let found = EntryDB.MainListStruct.MainList.contains{ $0.id == MainScreen.SaveListIDS[index2]+1}
                    /*
                    if(EntryDB.MainListStruct.MainList.contains{ $0.id == MainScreen.SaveListIDS[index2]+1}){
                        print("TAG5 item found")
                        print("TAG5 \(EntryDB.MainListStruct.MainList[index].id), \(MainScreen.SaveListIDS[index2]+1)")
                    } else {
                        print("TAG5 checkbox SWAP")
                        print("TAG5 \(EntryDB.MainListStruct.MainList[index].id), \(MainScreen.SaveListIDS[index2]+1)")
                        DBHelper.updateTableCheckboxPressed(arg: index)
                    }*/
                    
                    if(MainScreen.SaveListIDS.contains(EntryDB.MainListStruct.MainList[index].id-1)){
                        /*
                        print("TAG5 item found")
                        print("TAG5 \(EntryDB.MainListStruct.MainList[index].id), \(MainScreen.SaveListIDS[index2]+1)")
                        */
                    } else {
                        if(EntryDB.MainListStruct.MainList[index].status == "1"){
                            DBHelper.updateTableCheckboxPressed(arg:                         EntryDB.MainListStruct.MainList[index].id-1)
                        }
                    }
                }
                
                
            }
        }
    }
    */
    func refreshScreen(){
        MainTable.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        MainTable.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        EntryDB.ReturnFullTable(DBHelper)()
        
        //add check here
        
        self.MainTable.reloadData()
        
        //MainTable.rowHeight = UITableView.automaticDimension
        //MainTable.estimatedRowHeight = 100
        
       
        // #1.1 - Create "the notification's category value--its type."
        let debitOverdraftNotifCategory = UNNotificationCategory(identifier: "notificationPopup", actions: [], intentIdentifiers: [], options: [])
        // #1.2 - Register the notification type.
        UNUserNotificationCenter.current().setNotificationCategories([debitOverdraftNotifCategory])
        
        //sets timer with timeInterval in seconds
        _ = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(MainScreen.repeatingTimeCheck), userInfo: nil, repeats: true)
    }
    
    
    @objc func repeatingTimeCheck()
    {
        let defaults = UserDefaults.standard
        let myarray1 = defaults.stringArray(forKey: "Save1") ?? [String]()
        let myarray2 = defaults.array(forKey: "Save2") as? [Int] ?? [Int]()
        //let myarray3 = defaults.array(forKey: "Save3") ?? [String]()
        let myarray3 = "HA"
        //print("TAG5 \(myarray1) : \(myarray2) : \(MainScreen.NotificationArray)")
        //print("TAG5 \(EntryDB.MainListStruct.MainList)")
        print("TAG5 \(MainScreen.NotificationArray)")
        
        /*
        if(MainScreen.NotificationArray.isEmpty){
        }else{
            MainScreen().compareNotifications()
        }
 */
        
        //MainTable.reloadData()
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        let day = calendar.component(.weekday, from: date)
        
        var compareDay = ""
        if (day == 1){
            compareDay = "Sunday"
        } else if (day == 2){
            compareDay = "Monday"
        } else if (day == 3){
            compareDay = "Tuesday"
        } else if (day == 4){
            compareDay = "Wednesday"
        } else if (day == 5){
            compareDay = "Thursday"
        } else if (day == 6){
            compareDay = "Friday"
        } else if (day == 7){
            compareDay = "Saturday"
        }
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
                let second2 = calendar2.component(.second, from: date2)
                
                if(EntryDB.MainListStruct.MainList[index].status == "1" && hour == hour2 && minutes == minute2 && compareDay == EntryDB.MainListStruct.MainList[index].day && second2 == seconds){
                    DBHelper.updateTableCheckboxPressed(arg: EntryDB.MainListStruct.MainList[index].id-1)
                    self.MainTable.reloadData()
                    
                    notificatonCall(arg: index)
                } // end of time check code
                
            }
        }
    } // end of repeatingTimeCheck
    
    func notificatonCall(arg index:Int){
        // find out what are the user's notification preferences
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            
            // we're only going to create and schedule a notification
            // if the user has kept notifications authorized for this app
            guard settings.authorizationStatus == .authorized else { return }
            
            // create the content and style for the local notification
            let content = UNMutableNotificationContent()
            
            // #2.1 - "Assign a value to this property that matches the identifier
            // property of one of the UNNotificationCategory objects you
            // previously registered with your app."
            content.categoryIdentifier = "notificationPopup"
            
            // create the notification's content to be presented
            // to the user
            content.title = "Weekly Reset!"
            content.subtitle = "One or more of your weeklies have reset"
            content.body = "\(EntryDB.MainListStruct.MainList[index].name) "
            content.sound = UNNotificationSound.default
            
            // #2.2 - create a "trigger condition that causes a notification
            // to be delivered after the specified amount of time elapses";
            // deliver after 10 seconds
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
            
            // create a "request to schedule a local notification, which
            // includes the content of the notification and the trigger conditions for delivery"
            let uuidString = UUID().uuidString
            let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().delegate = self
            // "Upon calling this method, the system begins tracking the
            // trigger conditions associated with your request. When the
            // trigger condition is met, the system delivers your notification."
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        } // end getNotificationSettings
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        //displaying the ios local notification when app is in foreground
        completionHandler([.alert, .badge, .sound])
    }

}
