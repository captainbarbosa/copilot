//
//  ViewController.swift
//  copilot
//
//  Created by Nadia Barbosa on 10/18/18.
//  Copyright © 2018 Nadia Barbosa. All rights reserved.
//

import UIKit
import Mapbox
import MapboxCoreNavigation
import MapboxNavigation
import MapboxDirections
import UserNotifications

class ViewController: UIViewController, MGLMapViewDelegate {
    
    var mapView: MGLMapView!

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
        // Request permission to display alerts and play sounds.
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
        sendNotification()
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
            
            let navigationViewController = NavigationViewController(for: navigationRoute!)
            self.present(navigationViewController, animated: true, completion: nil)
        })
    }
    
    func sendNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Some title"
        content.body = "Some description"
        content.sound = UNNotificationSound.default
        
        // Create the request
        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString,
                                            content: content, trigger: nil)
        
        // Schedule the request with the system.
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.add(request) { (error) in
            if error != nil {
                print("❌ ERROR: \(error!)")
            }
        }
    }
}

