//
//  RunController.swift
//  Acceleration
//
//  Created by Igor Łopatka on 07/04/2022.
//

import Foundation
import SwiftUI


class TimerManager: ObservableObject {
    
    @Published var timer = Timer()
    @Published var counter = 0.00
    @Published var mode: Mode = .stopped
    
    func start() {
        if mode != .running {
            mode = .running
            timer = Timer.scheduledTimer(withTimeInterval: 1.0 / 60.0, repeats: true) { timer in
                self.counter += (1.0 / 60.0)
            }
        }
    }
    
    func reset() {
        timer.invalidate()
        counter = 0.0
        mode = .stopped
    }
    
    func stop() {
        if mode != .stopped {
            timer.invalidate()
            counter = 0
            mode = .stopped
        }
    }
    
    func pause() {
        timer.invalidate()
        mode = .paused
    }
}

