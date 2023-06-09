//
//  RunViewModel.swift
//  Acceleration
//
//  Created by Igor Łopatka on 14/01/2023.
//

import CoreLocation
import SwiftUI

class RunViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    @AppStorage("start") var start = 0
    @AppStorage("finish") var finish = 100
    @AppStorage("optRunActive") var optRunActive = false
    @AppStorage("optStart") var optStart = 100
    @AppStorage("optFinish") var optFinish = 200
    
    let values = [0,20,40,60,80,100,120,140,160,180,200,220,240,260,280,300]
    
    var timer = TimerManager()
    var optionalTimer = TimerManager()
    
    @Published var runActive = false
    @Published var runFinished = false
    
    @Published var authorizationStatus: CLAuthorizationStatus
    @Published var lastSeenLocation: CLLocation?
    
    @Published var unit = Unit.kph
    @Published var multiplier = 3.6
    @Published var title = "kmh"
    
    //MARK: - Location Manager State
    
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
    
    func requestPermission() {
        if authorizationStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lastSeenLocation = locations.first
    }
    
    var gpsAccuracy: Double {
        let accuracy =  lastSeenLocation?.horizontalAccuracy
        return Double(accuracy ?? 0)
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
    
    var speedInUnits: Double {
        let inUnits = speed * multiplier
        return inUnits
    }
    
    // MARK: - GPS Signal State
    
    var signalQuality: Signal {
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
    
    func updateSignalSymbol() -> String {
        if signalQuality == .none {
            return "antenna.radiowaves.left.and.right.slash"
        } else {
            return "antenna.radiowaves.left.and.right"
        }
    }
    
    func updateSignalColor() -> Color {
        switch signalQuality {
        case .good:
            return .green
        case .mediocre:
            return .yellow
        case .weak:
            return .red
        case .none:
            return .black
        }
    }
    
    //MARK: - Timer Managers State
    
    func updateRunState() {
        if timer.mode == .running || optionalTimer.mode == .running {
            runActive = true
        } else {
            runActive = false
        }
    }
    
    func resetTimers() {
        timer.reset()
        optionalTimer.reset()
    }
    
    //MARK: - Unit Manager State
    
    func updateUnits() {
        switch unit {
        case .kph:
            multiplier = 3.6
            title = "kmh"
        case .mph:
            multiplier = 2.2369
            title = "mph"
        }
    }
}
