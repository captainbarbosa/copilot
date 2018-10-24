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

    @IBOutlet weak var noRouteLabel: WKInterfaceLabel!

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        NotificationCenter.default.addObserver(self, selector: #selector(MainInterfaceController.didRecieveRouteSteps), name: NSNotification.Name(rawValue: "didRecieveRouteSteps"), object: nil)
    }
    
    @objc func didRecieveRouteSteps(notification: Notification) {
        print("🌈 didRecieveRouteSteps")
        
        guard let contextForWatch = notification.userInfo else { return }
        
        self.presentController(withName: "RouteInterfaceController", context: contextForWatch)
    }
}
