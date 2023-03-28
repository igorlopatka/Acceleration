//
//  locationController.swift
//  Acceleration
//
//  Created by Igor Łopatka on 05/04/2022.
//

import CoreLocation
import Foundation
import SwiftUI

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    @Published var authorizationStatus: CLAuthorizationStatus
    @Published var lastSeenLocation: CLLocation?
    
    private let locationManager: CLLocationManager
    
    override init() {
        locationManager = CLLocationManager()
        authorizationStatus = locationManager.authorizationStatus
        
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 0.4
        locationManager.startUpdatingLocation()
    }
    
    var speed: Double {
        let speedMS = lastSeenLocation?.speed ?? 0
        let speedDouble = Double(speedMS)
        
        if speedDouble <= 2 {
            return 0
        } else {
            return speedDouble
        }
    }
    
    var gpsSignalQuality: Signal {
        if (gpsAccuracy < 0) {
            return .none
        } else if (gpsAccuracy > 150) {
            return .weak
        } else if (gpsAccuracy > 50) {
            return .mediocre
        } else {
            return .good
        }
    }
    
    var gpsAccuracy: Double {
        let accuracy =  lastSeenLocation?.horizontalAccuracy
        return Double(accuracy ?? 0)
    }
    
    func requestPermission() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lastSeenLocation = locations.first
    }
}
