//
//  InterfaceController.swift
//  copilot-watch Extension
//
//  Created by Nadia Barbosa on 10/18/18.
//  Copyright © 2018 Nadia Barbosa. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity


class MainInterfaceController: WKInterfaceController {

    var routeSteps = [String]()
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        print("Main interface loaded")
        
        NotificationCenter.default.addObserver(self, selector: #selector(MainInterfaceController.didRecieveRouteSteps), name: NSNotification.Name(rawValue: "didRecieveRouteSteps"), object: nil)
        
        // Do generic setup for watch app here
        if routeSteps.isEmpty {
            print("No steps to show!")
        }
    }
    
    @objc func didRecieveRouteSteps(notification: Notification) {
        print("🌈 didRecieveRouteSteps")
        
        guard let routeSteps = notification.userInfo!["routeSteps"] else { return }
        self.presentController(withName: "RouteInterfaceController", context: routeSteps)
    }
}
