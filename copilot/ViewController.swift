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
        
        let options = NavigationRouteOptions(coordinates: [origin, destination], profileIdentifier: .automobileAvoidingTraffic)
        
        _ = Directions.shared.calculate(options, completionHandler: { (waypoints, routes, error) in
            navigationRoute = routes?.first
            
            let locationManager = SimulatedLocationManager(route: navigationRoute!)
            locationManager.speedMultiplier = 5
            
            let navigationService = MapboxNavigationService(route: navigationRoute!, locationSource: locationManager, simulating: .always)
            let navigationController = NavigationViewController(for: navigationRoute!, navigationService: navigationService)
            navigationController.delegate = self
            self.routeController = RouteController(along: navigationRoute, dataSource: locationManager)

            self.present(navigationController, animated: true, completion: nil)
        
            do {
                print("✅ Passing route to watch")
                try WatchSessionManager.sharedManager.updateApplicationContext(applicationContext: ["route" : navigationRoute.debugDescription as AnyObject])
            } catch {
                print("❌ Failed to pass route to watch")
            }
        })
    }
}

