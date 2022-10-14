//
//  Settings.swift
//  Acceleration
//
//  Created by Igor Łopatka on 12/04/2022.
//

import Foundation

class SettingsManager: ObservableObject {
    @Published var startRange = 0
    @Published var finishRange = 100
    @Published var optionalRunIsActive = false
    @Published var optionalStartRange = 100
    @Published var optionalFinishRange = 200
    @Published var unit = Units.kilometers
    @Published var unitsMultiplier = 3.6
    @Published var unitsTitle = "km/h"
    @Published var soundActive = true
    
    let values = [0,20,40,60,80,100,120,140,160,180,200,220,240,260,280,300]
    
    enum Units {
        case kilometers, miles
    }
    
    func updateUnits(unit: Units) {
        switch unit {
        case .kilometers:
            unitsMultiplier = 3.6
            unitsTitle = "km/h"
        case .miles:
            unitsMultiplier = 2.2369
            unitsTitle = "mi/h"
        }
    }
}
