//
//  SettingsView.swift
//  Acceleration
//
//  Created by Igor Łopatka on 14/03/2022.
//

import SwiftUI

struct RunRowListView: View {
    
    @ObservedObject var vm: RunViewModel
    @ObservedObject var range: RangeManager
    @ObservedObject var timer: TimerManager
    @ObservedObject var optTimer: TimerManager
    
    var body: some View {
        VStack {
            HStack {
                RunRowView(start: $range.start, finish: $range.finish, active: $vm.runActive)
                Text((String(format: "%.1f", timer.counter)) + "s")
                    .bold()
                    .frame(width: 50)
            }
            if range.optRunActive {
                HStack {
                    RunRowView(start: $range.optStart, finish: $range.optFinish, active: $vm.runActive)
                    Text((String(format: "%.1f", optTimer.counter)) + "s")
                        .bold()
                        .frame(width: 50)
                }

            }
            Button {
                withAnimation {
                    range.optRunActive.toggle()
                }
            } label: {
                Image(systemName: range.optRunActive ? "minus.circle" : "plus.circle")
                    .tint(range.optRunActive ? .gray : .green)
            }
            .padding(.trailing, 60)
        }
        .padding(.trailing, 50)
    }
}


struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        RunRowListView(vm: RunViewModel(), range: RangeManager(), timer: TimerManager(), optTimer: TimerManager())
    }
}
