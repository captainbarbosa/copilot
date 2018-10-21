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


class InterfaceController: WKInterfaceController {
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        loadTableData()
    }

    @IBOutlet weak var watchTable: WKInterfaceTable!
    let names = ["SF", "DC", "NY"]
    
    private func loadTableData() {
        watchTable.setNumberOfRows(names.count, withRowType: "TableRowController")
        
        for (index, name) in names.enumerated() {
            let row = watchTable.rowController(at: index) as! TableRowController
            row.tableRowLabel.setText(name)
            
        }
    }
}
