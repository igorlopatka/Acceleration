//
//  RunViewModel.swift
//  Acceleration
//
//  Created by Igor Łopatka on 14/01/2023.
//

import SwiftUI

class RunViewModel: ObservableObject {
    
    @StateObject var timer = TimerManager()
    @StateObject var optionalTimer = TimerManager()
    
    
    
}
