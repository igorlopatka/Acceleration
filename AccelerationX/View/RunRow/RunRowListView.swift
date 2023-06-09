//
//  SettingsView.swift
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
        VStack {
            HStack {
                RunRowView(start: $vm.start, finish: $vm.finish, active: $vm.runActive)
                Text((String(format: "%.1f", timer.counter)) + "s")
                    .bold()
                    .frame(width: 50)
            }
            if vm.optRunActive {
                HStack {
                    RunRowView(start: $vm.optStart, finish: $vm.optFinish, active: $vm.runActive)
                    Text((String(format: "%.1f", optTimer.counter)) + "s")
                        .bold()
                        .frame(width: 50)
                }

            }
            Button {
                withAnimation {
                    vm.optRunActive.toggle()
                }
            } label: {
                Image(systemName: vm.optRunActive ? "minus.circle" : "plus.circle")
                    .tint(vm.optRunActive ? .gray : .green)
            }
            .padding(.trailing, 60)
        }
        .padding(.trailing, 50)
    }
}


struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        RunRowListView(vm: RunViewModel(), timer: TimerManager(), optTimer: TimerManager())
    }
}
