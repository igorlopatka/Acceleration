//
//  AccelerationViewModel.swift
//  Acceleration
//
//  Created by Igor Łopatka on 16/12/2022.
//

import SwiftUI

class AccelerationViewModel: ObservableObject {
    
    @Environment(\.managedObjectContext) var context
    @Environment(\.dismiss) var dismiss
    
    @StateObject var locationController = LocationManager()
    @StateObject var timer = TimerManager()
    @StateObject var optionalTimer = TimerManager()
    
    @Published var startRange = 0
    @Published var finishRange = 100
    @Published var optionalRunIsActive = false
    @Published var optionalStartRange = 100
    @Published var optionalFinishRange = 200
    
    @Published var showAlert = false
    @Published var unit = Unit.kph
    @Published var unitsMultiplier = 3.6
    @Published var unitsTitle = "km/h"
    
    let values = [0,20,40,60,80,100,120,140,160,180,200,220,240,260,280,300]
    
}
