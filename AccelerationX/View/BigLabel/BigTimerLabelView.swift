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

    var body: some View {
        VStack(spacing: 6) {
            HStack(alignment: .bottom, spacing: 8) {
                Text(String(format: "%.2f", displayCounter))
                    .font(.custom("VCR OSD Mono", size: 80))
                    .foregroundStyle(.white)
                    .contentTransition(.numericText(countsDown: false))
                    .animation(.easeOut(duration: 0.05), value: displayCounter)

                Text("SEC")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(.secondary)
                    .tracking(3)
                    .padding(.bottom, 14)
            }

            Text(timerLabel)
                .font(.system(size: 10, weight: .medium))
                .foregroundStyle(Color.pink.opacity(0.8))
                .tracking(4)
        }
    }
}
