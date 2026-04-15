//
//  RunViewModel.swift
//  Acceleration
//
//  Created by Igor Łopatka on 14/01/2023.
//

import CoreLocation
import SwiftUI

class RunViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {

    @AppStorage("start")      var start      = 0
    @AppStorage("finish")     var finish      = 100
    @AppStorage("optRunActive") var optRunActive = false
    @AppStorage("optStart")   var optStart    = 100
    @AppStorage("optFinish")  var optFinish   = 200

    let values = [0, 20, 40, 60, 80, 100, 120, 140, 160, 180, 200, 220, 240, 260, 280, 300]

    var timer         = TimerManager()
    var optionalTimer = TimerManager()

    @Published var runActive   = false
    @Published var runFinished = false
    @Published var peakSpeed   = 0.0

    @Published var authorizationStatus: CLAuthorizationStatus
    @Published var lastSeenLocation: CLLocation?

    @Published var unit       = Unit.kph
    @Published var multiplier = 3.6
    @Published var title      = "kmh"

    // MARK: - Location Manager

    private let locationManager: CLLocationManager

    override init() {
        locationManager = CLLocationManager()
        authorizationStatus = locationManager.authorizationStatus
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.distanceFilter  = kCLDistanceFilterNone
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
        // Track peak speed (only while a run is in progress or has started)
        let current = speedInUnits
        if current > peakSpeed {
            peakSpeed = current
        }
    }

    // MARK: - Speed

    /// Raw speed in m/s. Returns 0 for invalid, unavailable, or very low readings.
    var speed: Double {
        guard let location = lastSeenLocation,
              location.speedAccuracy >= 0,
              location.speed > 0 else { return 0 }
        let speedMS = location.speed
        return speedMS <= 2.0 ? 0 : speedMS
    }

    var speedInUnits: Double {
        speed * multiplier
    }

    // MARK: - GPS Signal Quality

    /// Returns signal quality based on horizontal accuracy.
    /// Returns `.none` when no location fix has been obtained.
    var signalQuality: Signal {
        guard let location = lastSeenLocation else { return .none }
        let accuracy = location.horizontalAccuracy
        if accuracy < 0   { return .none }
        if accuracy > 150 { return .weak }
        if accuracy > 50  { return .mediocre }
        return .good
    }

    // MARK: - Timer State

    func updateRunState() {
        runActive = timer.mode == .running || optionalTimer.mode == .running
    }

    func resetTimers() {
        timer.reset()
        optionalTimer.reset()
        peakSpeed = 0.0
    }

    // MARK: - Units

    func updateUnits() {
        switch unit {
        case .kph:
            multiplier = 3.6
            title = "kmh"
        case .mph:
            multiplier = 2.23694
            title = "mph"
        }
    }
}
