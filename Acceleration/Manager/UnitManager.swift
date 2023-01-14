//
//  UnitManager.swift
//  Acceleration
//
//  Created by Igor Łopatka on 14/01/2023.
//

import Foundation
import SwiftUI

class UnitManager: ObservableObject {
    
    @Published var unit = Unit.kph
    @Published var unitsMultiplier = 3.6
    @Published var unitsTitle = "kmh"
    
    func updateUnits(unit: Unit) {
        switch unit {
        case .kph:
            unitsMultiplier = 3.6
            unitsTitle = "kmh"
        case .mph:
            unitsMultiplier = 2.2369
            unitsTitle = "mph"
        }
    }
}
