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
    }
    
    @IBOutlet weak var NotificationText: UITextView!
    
    func didReceive(_ notification: UNNotification) {
        self.label?.text = notification.request.content.body
        
        NotificationText.text = "Your notification has been reset rewuuoanfoiewnafoiehwraoihewoarihwoehraiwuebraliuwberliubeawilurbielubarliuewbarliuewarlihewairewiahrhewliuanrilewuanfliuewafviewnaoiweniufnreoig;niogoberowgberotbworegob4oubrotub4ou3bgto4ubwgobwgoewhbgo4ebgwpoub4"
    }

}
