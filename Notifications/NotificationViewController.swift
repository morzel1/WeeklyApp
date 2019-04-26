//
//  NotificationViewController.swift
//  Notifications
//
//  Created by Mike on 4/22/19.
//  Copyright © 2019 rdm. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI

class NotificationViewController: UIViewController, UNNotificationContentExtension {

    @IBOutlet var label: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any required interface initialization here.
        
        // #1.1 - Create "the notification's category value--its type."
        let debitOverdraftNotifCategory = UNNotificationCategory(identifier: "notificationPopup", actions: [], intentIdentifiers: [], options: [])
        // #1.2 - Register the notification type.
        UNUserNotificationCenter.current().setNotificationCategories([debitOverdraftNotifCategory])
        
    }
    
    @IBOutlet weak var NotificationText: UITextView!
    
    func didReceive(_ notification: UNNotification) {
        self.label?.text = notification.request.content.body
        
        NotificationText.text = "Your weekly has been reset rewuuoanfoiewnafoiehwraoihewoarihwoehraiwuebraliuwberliubeawilurbielubarliuewbarliuewarlihewairewiahrhewliuanrilewuanfliuewafviewnaoiweniufnreoig;niogoberowgberotbworegob4oubrotub4ou3bgto4ubwgobwgoewhbgo4ebgwpoub4"
    }

}
