//
//  RunRange.swift
//  Acceleration
//
//  Created by Igor Łopatka on 11/01/2023.
//

import Foundation

class RunRange: ObservableObject {
    
     @Published var start = 0
     @Published var finish = 100
    
    let values = [0,20,40,60,80,100,120,140,160,180,200,220,240,260,280,300]
}
