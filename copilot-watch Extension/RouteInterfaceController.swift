import WatchKit
import Foundation


class RouteInterfaceController: WKInterfaceController {

    @IBOutlet weak var routeStepTable: WKInterfaceTable!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        let routeSteps = context as! [String]

        routeStepTable.setNumberOfRows(routeSteps.count, withRowType: "TableRowController")
        
        for (index, routeStep) in routeSteps.enumerated() {
            let row = routeStepTable.rowController(at: index) as! TableRowController
            row.tableRowLabel.setText(routeStep)
            
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
            
            row.tableRowImage.setImageNamed(routeStepImage)
        }
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
}
