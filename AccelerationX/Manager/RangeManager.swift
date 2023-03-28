//
//  Settings.swift
//  Acceleration
//
//  Created by Igor Łopatka on 12/04/2022.
//

import SwiftUI

class RangeManager: ObservableObject {
    
    @AppStorage("start") var start = 0
    @AppStorage("finish") var finish = 100
    @AppStorage("optRunActive") var optRunActive = false
    @AppStorage("optStart") var optStart = 100
    @AppStorage("optFinish") var optFinish = 200
    
    let values = [0,20,40,60,80,100,120,140,160,180,200,220,240,260,280,300]
}
