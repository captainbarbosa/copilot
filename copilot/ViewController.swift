import UIKit
import Mapbox
import MapboxCoreNavigation
import MapboxNavigation
import MapboxDirections
import UserNotifications
import WatchConnectivity

class ViewController: UIViewController, MGLMapViewDelegate, NavigationViewControllerDelegate {
    
    var mapView: MGLMapView!
    var routeController: RouteController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView = MGLMapView(frame: view.bounds)
        mapView.delegate = self
        mapView.userTrackingMode = .follow
        view.addSubview(mapView)
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(handleMapTap(sender:)))
        for recognizer in mapView.gestureRecognizers! where recognizer is UITapGestureRecognizer {
            singleTap.require(toFail: recognizer)
        }
        mapView.addGestureRecognizer(singleTap)
        
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound])
        { (granted, error) in
            // Enable or disable features based on authorization.
        }
    }
    
    @objc @IBAction func handleMapTap(sender: UITapGestureRecognizer) {
        
        if let annotations = mapView.annotations {
            mapView.removeAnnotations(annotations)
        }
        
        let tapPoint: CGPoint = sender.location(in: mapView)
        let annotation = MGLPointAnnotation()
        annotation.title = "Navigate here!"
        annotation.coordinate = mapView.convert(tapPoint, toCoordinateFrom: mapView)
        mapView.addAnnotation(annotation)
    }
    
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    
    func mapView(_ mapView: MGLMapView, tapOnCalloutFor annotation: MGLAnnotation) {
        guard let origin = mapView.userLocation?.coordinate else { return }
        let destination = annotation.coordinate
        var navigationRoute: Route!
        
        let options = NavigationRouteOptions(coordinates: [origin, destination], profileIdentifier: .walking)
        
        _ = Directions.shared.calculate(options, completionHandler: { (waypoints, routes, error) in
            navigationRoute = routes?.first

            let navigationViewController = NavigationViewController(for: navigationRoute!)
            self.present(navigationViewController, animated: true, completion: nil)
        
            do {
                print("✅ Passing route to watch")
                let route = navigationRoute
                let routeLegs = route!.legs[0]
                let routeSteps = routeLegs.steps
                
                var routeStepTitles = [String]()
                
                for routeStep in routeSteps {
                    routeStepTitles.append(routeStep.instructions)
                }
                
                let contextForWatch = [
                    "expectedTravelTime" : route?.expectedTravelTime as AnyObject,
                    "distance" : route?.distance as AnyObject,
                    "routeSteps" : routeStepTitles as AnyObject
                ]
                
                try WatchSessionManager.sharedManager.updateApplicationContext(applicationContext: contextForWatch)
            } catch {
                print("❌ Failed to pass route to watch")
            }
        })
    }
}

