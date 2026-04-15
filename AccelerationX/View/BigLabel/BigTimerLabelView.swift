//
//  TimerBigLabelView.swift
//  Acceleration
//
//  Created by Igor Łopatka on 17/01/2023.
//

import SwiftUI

struct BigTimerLabelView: View {

    @ObservedObject var timer: TimerManager
    @ObservedObject var optionalTimer: TimerManager

    private var displayCounter: Double {
        optionalTimer.mode == .running ? optionalTimer.counter : timer.counter
    }

    private var timerLabel: String {
        optionalTimer.mode == .running ? "TIMER 2" : "TIMER 1"
    }

    private var isRunning: Bool {
        timer.mode == .running || optionalTimer.mode == .running
    }

    var body: some View {
        VStack(spacing: 4) {
            HStack(alignment: .bottom, spacing: 6) {
                Text(String(format: "%.2f", displayCounter))
                    .font(.custom("VCR OSD Mono", size: 72))
                    .foregroundStyle(isRunning ? Color.pink : .white)
                    .shadow(color: isRunning ? Color.pink.opacity(0.45) : .clear, radius: 10)
                    .contentTransition(.numericText(countsDown: false))
                    .animation(.easeOut(duration: 0.05), value: displayCounter)

                Text("SEC")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(Color(white: 0.38))
                    .tracking(3)
                    .padding(.bottom, 12)
            }

            Text(timerLabel)
                .font(.system(size: 10, weight: .medium))
                .foregroundStyle(Color.pink.opacity(0.7))
                .tracking(4)
        }
    }
}
