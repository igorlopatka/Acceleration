//
//  Settings.swift
//  Acceleration
//
//  Created by Igor Łopatka on 12/04/2022.
//

import Foundation

class RangeManager: ObservableObject {
    
    @Published var start = 0
    @Published var finish = 100
    @Published var optRunActive = false
    @Published var optStart = 100
    @Published var optFinish = 200
    
    let values = [0,20,40,60,80,100,120,140,160,180,200,220,240,260,280,300]
}
