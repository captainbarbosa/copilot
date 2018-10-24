import WatchKit
import Foundation


class RouteInterfaceController: WKInterfaceController {

    @IBOutlet weak var routeStepTable: WKInterfaceTable!
    @IBOutlet weak var estimatedTravelTimeLabel: WKInterfaceLabel!
    @IBOutlet weak var distanceLabel: WKInterfaceLabel!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        guard let contextForWatch = context as? NSDictionary else { return }
        
        let seconds = contextForWatch["expectedTravelTime"] as! TimeInterval
        let distance = contextForWatch["distance"] as! CLLocationDistance
        let routeSteps = contextForWatch["routeSteps"] as! [String]
        
        setEstimatedTravelTime(for: estimatedTravelTimeLabel, with: seconds)
        setRouteDistance(for: distanceLabel, with: distance)
        setTableRows(for: routeStepTable, with: routeSteps)
    }
    
    func setEstimatedTravelTime(for label: WKInterfaceLabel, with seconds: TimeInterval) {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .short
        formatter.allowedUnits = [.day, .hour, .minute]
        estimatedTravelTimeLabel.setText(formatter.string(from: seconds))
    }
    
    func setRouteDistance(for label: WKInterfaceLabel, with distance: CLLocationDistance) {
        let formatter = MeasurementFormatter()
        let measurement = Measurement(value: distance, unit: Unit(symbol: "m"))
        formatter.unitStyle = .medium
        formatter.locale = Locale.current
        let result = formatter.string(for: measurement)
        distanceLabel.setText(result)
    }
    
    func setTableRows(for table: WKInterfaceTable, with routeSteps: [String]) {
        table.setNumberOfRows(routeSteps.count, withRowType: "TableRowController")
        
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
