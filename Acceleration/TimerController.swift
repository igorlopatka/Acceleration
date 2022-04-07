//
//  RunController.swift
//  Acceleration
//
//  Created by Igor Łopatka on 07/04/2022.
//

import Foundation
import SwiftUI


class TimerController: ObservableObject {
    
    @Published var counter = 0.00
    @Published var mode: mode = .stopped
    var timer = Timer()
    
    func start() {
        mode = .running
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            self.counter += 0.1
        }
    }
    
    func stop() {
        timer.invalidate()
        counter = 0
        mode = .stopped
    }
    
    func pause() {
        timer.invalidate()
        mode = .paused
    }
    
}

enum mode {
    case running
    case stopped
    case paused
}
