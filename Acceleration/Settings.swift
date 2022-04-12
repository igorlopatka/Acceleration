//
//  Settings.swift
//  Acceleration
//
//  Created by Igor Łopatka on 12/04/2022.
//

import Foundation

class Settings: ObservableObject {
    @Published var startRange = 0
    @Published var finishRange = 100
    @Published var optionalRunIsActive = false
    @Published var optionalStartRange = 100
    @Published var optionalFinishRange = 200
    @Published var unitsMultiplier = 3.6
    @Published var soundIsOn = true
    
    let values = [0,20,40,60,80,100,120,140,160,180,200,220,240,260,280,300]
    
    
}
