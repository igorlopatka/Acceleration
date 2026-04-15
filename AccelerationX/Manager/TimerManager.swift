//
//  RunController.swift
//  Acceleration
//
//  Created by Igor Łopatka on 07/04/2022.
//

import Foundation

class TimerManager: ObservableObject {

    @Published var counter = 0.0
    @Published var mode: Mode = .stopped

    private var timer: Timer?
    private var startDate: Date?

    /// Starts the timer from zero. No-op if already running or already has a result.
    func start() {
        guard counter == 0.0, mode != .running else { return }
        mode = .running
        let capturedStart = Date()
        startDate = capturedStart
        timer = Timer.scheduledTimer(withTimeInterval: 1.0 / 60.0, repeats: true) { [weak self] _ in
            self?.counter = Date().timeIntervalSince(capturedStart)
        }
    }

    /// Freezes the counter at its current value without resetting.
    func pause() {
        timer?.invalidate()
        timer = nil
        startDate = nil
        mode = .paused
    }

    /// Stops and resets the counter to zero.
    func reset() {
        timer?.invalidate()
        timer = nil
        startDate = nil
        counter = 0.0
        mode = .stopped
    }

    /// Stops and resets (alias kept for compatibility).
    func stop() {
        reset()
    }
}
