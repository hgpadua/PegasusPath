//
//  ViewController.swift
//  PegasusPath
//
//  Created by Christopher Donoso on 2/21/18.
//  Copyright © 2018 Christopher Donoso. All rights reserved.
//

import UIKit
import Mapbox
import MapboxCoreNavigation
import MapboxNavigation
import MapboxDirections

class ViewController: UIViewController, MGLMapViewDelegate {
    
    private var ucf: MGLCoordinateBounds!
    var mapView: NavigationMapView!
    var directionRoute: Route?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView = NavigationMapView(frame: view.bounds)
        view.addSubview(mapView)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        //Set the map view's delegate
        mapView.delegate = self
        
        // UCF, Orlando, Florida
        let center = CLLocationCoordinate2D(latitude: 28.6024, longitude: -81.2001)
        
        // Starting point
        mapView.setCenter(center, zoomLevel: 14, direction: 0, animated: false)
        
        // UCF's bounds
        let ne = CLLocationCoordinate2D(latitude: 28.6345, longitude: -81.17340)
        let sw = CLLocationCoordinate2D(latitude: 28.5820, longitude: -81.2241)
        ucf = MGLCoordinateBounds(sw: sw, ne: ne)
        
        //Alow the map to display the user's location
        mapView.showsUserLocation = true
        //mapView.setUserTrackingMode(.follow, animated: true)
        
        //Add a gesture recognizer to the map view
        let setDestination = UILongPressGestureRecognizer(target: self, action: #selector(didLongPress(_:)))
        mapView.addGestureRecognizer(setDestination)
    }
    
    // Restricts the camera movement.
    func mapView(_ mapView: MGLMapView, shouldChangeFrom oldCamera: MGLMapCamera, to newCamera: MGLMapCamera) -> Bool {
        
        // Get the current camera to restore it after.
        let currentCamera = mapView.camera
        
        // From the new camera obtain the center to test if it’s inside the boundaries.
        let newCameraCenter = newCamera.centerCoordinate
        
        // Set the map’s visible bounds to newCamera.
        mapView.camera = newCamera
        let newVisibleCoordinates = mapView.visibleCoordinateBounds
        
        // Revert the camera.
        mapView.camera = currentCamera
        
        // Test if the newCameraCenter and newVisibleCoordinates are inside self.ucf.
        let inside = MGLCoordinateInCoordinateBounds(newCameraCenter, self.ucf)
        let intersects = MGLCoordinateInCoordinateBounds(newVisibleCoordinates.ne, self.ucf) && MGLCoordinateInCoordinateBounds(newVisibleCoordinates.sw, self.ucf)
        
        return inside && intersects
    }
    
    // Called when user long presses on the map.
    @objc func didLongPress(_ sender: UILongPressGestureRecognizer) {
        guard sender.state == .began else { return }
        
        // Converts point where user did a long press to map coordinates
        let point = sender.location(in: mapView)
        let coordinate = mapView.convert(point, toCoordinateFrom: mapView)
        
        // Create a basic point annotation and add it to the map
        let annotation = MGLPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "Start navigation"
        mapView.addAnnotation(annotation)
    }
}
