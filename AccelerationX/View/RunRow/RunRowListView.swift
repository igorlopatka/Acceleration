//
//  RunRowListView.swift
//  Acceleration
//
//  Created by Igor Łopatka on 14/03/2022.
//

import SwiftUI

struct RunRowListView: View {

    @ObservedObject var vm: RunViewModel
    @ObservedObject var timer: TimerManager
    @ObservedObject var optTimer: TimerManager

    var body: some View {
        VStack(spacing: 12) {
            // Primary timer row
            timerRow(
                label: "T1",
                start: $vm.start,
                finish: $vm.finish,
                counter: timer.counter
            )

            if vm.optRunActive {
                Divider()
                    .background(Color(white: 0.25))

                // Optional timer row
                timerRow(
                    label: "T2",
                    start: $vm.optStart,
                    finish: $vm.optFinish,
                    counter: optTimer.counter
                )
            }

            // Add / remove Timer 2 button
            Button {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    vm.optRunActive.toggle()
                }
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: vm.optRunActive ? "minus" : "plus")
                        .font(.system(size: 12, weight: .bold))
                    Text(vm.optRunActive ? "Remove Timer 2" : "Add Timer 2")
                        .font(.system(size: 13, weight: .medium))
                }
                .foregroundStyle(vm.optRunActive ? Color.secondary : Color.pink)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .background(Color(white: 0.18))
                .cornerRadius(10)
            }
            .buttonStyle(.plain)
            .disabled(vm.runActive)
        }
        .padding(16)
        .background(Color(white: 0.12))
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color(white: 0.22), lineWidth: 0.5)
        )
    }

    @ViewBuilder
    private func timerRow(label: String, start: Binding<Int>, finish: Binding<Int>, counter: Double) -> some View {
        HStack(spacing: 8) {
            Text(label)
                .font(.system(size: 11, weight: .semibold))
                .foregroundStyle(.secondary)
                .tracking(2)
                .frame(width: 20)

            RunRowView(start: start, finish: finish, active: $vm.runActive)

            Spacer()

            Text(String(format: "%.2f", counter) + "s")
                .font(.system(size: 15, weight: .bold, design: .monospaced))
                .foregroundStyle(.white)
                .frame(minWidth: 65, alignment: .trailing)
        }
    }
}

struct RunRowListView_Previews: PreviewProvider {
    static var previews: some View {
        RunRowListView(vm: RunViewModel(), timer: TimerManager(), optTimer: TimerManager())
            .preferredColorScheme(.dark)
            .padding()
    }
}
