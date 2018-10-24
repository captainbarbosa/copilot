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
        let routeStep = notification.request.content.body
        
        var routeStepImage = String()
        
        switch routeStep {
        case let step where step.contains("south"):
            routeStepImage = "south"
            break
        case let step where step.contains("north"):
            routeStepImage = "north"
            break
        case let step where step.contains("right"):
            routeStepImage = "turn-right"
            break
        case let step where step.contains("left"):
            routeStepImage = "turn-left"
            break
        case let step where step.contains("arrive"):
            routeStepImage = "arrive"
            break
        default:
            break
        }

        stepAlertLabel.setText(routeStep)
        stepAlertImage.setImageNamed(routeStepImage)
        
        completionHandler(.custom)
    }
}
