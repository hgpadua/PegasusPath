//
//  ViewController.swift
//  PegasusPath
//
//  Created by Christopher Donoso on 2/21/18.
//  Copyright © 2018 Christopher Donoso. All rights reserved.
//

import UIKit
import Mapbox

class ViewController: UIViewController, MGLMapViewDelegate {
    
    private var ucf: MGLCoordinateBounds!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mapView = MGLMapView(frame: view.bounds)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.delegate = self
        
        // UCF, Orlando, Florida
        let center = CLLocationCoordinate2D(latitude: 28.6024, longitude: -81.2001)
        
        // Starting point
        mapView.setCenter(center, zoomLevel: 14, direction: 0, animated: false)
        
        // UCF's bounds
        let ne = CLLocationCoordinate2D(latitude: 28.6345, longitude: -81.17340)
        let sw = CLLocationCoordinate2D(latitude: 28.5820, longitude: -81.2241)
        ucf = MGLCoordinateBounds(sw: sw, ne: ne)
        
        view.addSubview(mapView)
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
}
