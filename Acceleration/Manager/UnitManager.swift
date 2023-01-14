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
    @Published var multiplier = 3.6
    @Published var title = "kmh"
    
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
