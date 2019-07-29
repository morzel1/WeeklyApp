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
import GoogleMobileAds
import AudioToolbox

class MainScreen: UIViewController, UITableViewDelegate, UITableViewDataSource, UNUserNotificationCenterDelegate, GADBannerViewDelegate{
    
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
        }
        
        
    }
    
    //Table view code
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return EntryDB.MainListStruct.MainList.count
    }
//5-9
    let checkedImage = UIImage(named: "checked-checkbox-128")! as UIImage
    let uncheckedImage = UIImage(named: "test22")! as UIImage
    

    
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

    func refreshScreen(){
        MainTable.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        MainTable.reloadData()
    }
    
    var adMobBannerView = GADBannerView()
    
    //real banner
    let ADMOB_BANNER_UNIT_ID = "ca-app-pub-2287959670984169/7335978702"

    //test banner
    //let ADMOB_BANNER_UNIT_ID = "ca-app-pub-3940256099942544/2934735716"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        EntryDB.ReturnFullTable(DBHelper)()
        
        //add check here
        
        self.MainTable.reloadData()
        
        initAdMobBanner()
        
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
    
    
    // MARK: -  ADMOB BANNER
    func initAdMobBanner() {
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            // iPhone
            adMobBannerView.adSize =  GADAdSizeFromCGSize(CGSize(width: 320, height: 50))
            adMobBannerView.frame = CGRect(x: 0, y: view.frame.size.height, width: 320, height: 50)
        } else  {
            // iPad
            adMobBannerView.adSize =  GADAdSizeFromCGSize(CGSize(width: 468, height: 60))
            adMobBannerView.frame = CGRect(x: 0, y: view.frame.size.height, width: 468, height: 60)
        }
        
        adMobBannerView.adUnitID = ADMOB_BANNER_UNIT_ID
        adMobBannerView.rootViewController = self
        adMobBannerView.delegate = self
        view.addSubview(adMobBannerView)
        
        let request = GADRequest()
        adMobBannerView.load(request)
    }
    
    
    // Hide the banner
    func hideBanner(_ banner: UIView) {
        UIView.beginAnimations("hideBanner", context: nil)
        banner.frame = CGRect(x: view.frame.size.width/2 - banner.frame.size.width/2, y: view.frame.size.height - banner.frame.size.height, width: banner.frame.size.width, height: banner.frame.size.height)
        UIView.commitAnimations()
        banner.isHidden = true
    }
    
    // Show the banner
    func showBanner(_ banner: UIView) {
        UIView.beginAnimations("showBanner", context: nil)
        banner.frame = CGRect(x: view.frame.size.width/2 - banner.frame.size.width/2, y: view.frame.size.height - banner.frame.size.height, width: banner.frame.size.width, height: banner.frame.size.height)
        UIView.commitAnimations()
        banner.isHidden = false
    }
    
    // AdMob banner available
    func adViewDidReceiveAd(_ view: GADBannerView) {
        showBanner(adMobBannerView)
    }
    
    // NO AdMob banner available
    func adView(_ view: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        hideBanner(adMobBannerView)
    }

}
