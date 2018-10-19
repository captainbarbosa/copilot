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

    @IBOutlet weak var alertLabel: WKInterfaceLabel!
    
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
        completionHandler(.custom)
    }
    
    override func didReceiveRemoteNotification(_ remoteNotification: [AnyHashable : Any], withCompletion completionHandler: @escaping (WKUserNotificationInterfaceType) -> Void) {
            // This method is called when a remote notification needs to be presented.
            // Implement it if you use a dynamic notification interface.
            // Populate your dynamic notification interface as quickly as possible.
    
            guard let aps = remoteNotification["aps"] as? NSDictionary,
                  let alert = aps["alert"] as? NSDictionary,
                  let body = alert["body"] as? String else {
                    // If the APNS payload doesn't have what we need, fall back to static notification
                    completionHandler(.default)
                    return
            }
    
        alertLabel.setText(body)
//            weatherLabel.setText(dataSource.currentWeather.temperatureString)
    //        conditionsImage.setImageNamed(dataSource.currentWeather.weatherConditionImageName)
    
            // After populating your dynamic notification interface call the completion block.
            completionHandler(.custom)
    }
}
