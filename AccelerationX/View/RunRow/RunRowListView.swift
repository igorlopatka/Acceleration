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
        VStack(spacing: 10) {
            timerRow(
                label: "T1",
                start: $vm.start,
                finish: $vm.finish,
                counter: timer.counter,
                isActive: timer.mode == .running
            )

            if vm.optRunActive {
                Divider()
                    .background(Color(white: 0.2))

                timerRow(
                    label: "T2",
                    start: $vm.optStart,
                    finish: $vm.optFinish,
                    counter: optTimer.counter,
                    isActive: optTimer.mode == .running
                )
            }

            addRemoveButton
        }
        .padding(14)
        .background(Color(white: 0.10))
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color(white: 0.20), lineWidth: 0.5)
        )
    }

    @ViewBuilder
    private func timerRow(
        label: String,
        start: Binding<Int>,
        finish: Binding<Int>,
        counter: Double,
        isActive: Bool
    ) -> some View {
        HStack(spacing: 8) {
            Text(label)
                .font(.system(size: 10, weight: .bold))
                .foregroundStyle(isActive ? .pink : Color(white: 0.38))
                .tracking(2)
                .frame(width: 18)

            RunRowView(start: start, finish: finish, active: $vm.runActive)

            Spacer()

            Text(String(format: "%.2f", counter) + "s")
                .font(.system(size: 15, weight: .bold, design: .monospaced))
                .foregroundStyle(isActive ? .pink : .white)
                .shadow(color: isActive ? Color.pink.opacity(0.4) : .clear, radius: 6)
                .frame(minWidth: 65, alignment: .trailing)
        }
    }

    private var addRemoveButton: some View {
        Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                vm.optRunActive.toggle()
            }
        } label: {
            HStack(spacing: 6) {
                Image(systemName: vm.optRunActive ? "minus.circle" : "plus.circle")
                    .font(.system(size: 13))
                Text(vm.optRunActive ? "Remove Timer 2" : "Add Timer 2")
                    .font(.system(size: 13, weight: .medium))
            }
            .foregroundStyle(vm.optRunActive ? Color(white: 0.42) : .pink)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .background(Color(white: 0.14))
            .cornerRadius(10)
        }
        .buttonStyle(.plain)
        .disabled(vm.runActive)
    }
}

struct RunRowListView_Previews: PreviewProvider {
    static var previews: some View {
        RunRowListView(vm: RunViewModel(), timer: TimerManager(), optTimer: TimerManager())
            .preferredColorScheme(.dark)
            .padding()
    }
}
