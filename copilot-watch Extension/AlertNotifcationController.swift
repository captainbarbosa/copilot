//
//  AlertNotifcationController.swift
//  copilot-watch Extension
//
//  Created by Nadia Barbosa on 10/19/18.
//  Copyright © 2018 Nadia Barbosa. All rights reserved.
//

import WatchKit
import Foundation
import UserNotifications


class AlertNotifcationController: WKUserNotificationInterfaceController {

    
    @IBOutlet weak var stepAlertImage: WKInterfaceImage!
    @IBOutlet weak var stepAlertLabel: WKInterfaceLabel!
    
    override init() {
        // Initialize variables here.
        super.init()
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }


    override func didReceive(_ notification: UNNotification, withCompletion completionHandler: @escaping (WKUserNotificationInterfaceType) -> Swift.Void) {
        // This method is called when a notification needs to be presented.
        // Implement it if you use a dynamic notification interface.
        // Populate your dynamic notification interface as quickly as possible.
        //
        // After populating your dynamic notification interface call the completion block.
        let instruction = notification.request.content.body
        stepAlertLabel.setText(instruction)
        
        if instruction.contains("left") {
            stepAlertImage.setImageNamed("turn-left")
            stepAlertImage.setTintColor(UIColor.red)
        }
        
        if instruction.contains("right") {
            stepAlertImage.setImageNamed("turn-right")
            stepAlertImage.setTintColor(UIColor.red)
        }
        
        completionHandler(.custom)
    }
}
