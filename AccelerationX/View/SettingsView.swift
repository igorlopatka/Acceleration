//
//  SettingsView.swift
//  Acceleration
//
//  Created by Igor Łopatka on 27/02/2023.
//

import SwiftUI

struct SettingsView: View {
    
    @ObservedObject var vm: RunViewModel
    @State private var showAbout = false
    
    var unitSelected: String {
        switch vm.unit {
        case .kph:
            return "Kilometers per hour"
        case .mph:
            return "Miles per hour"
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("First run")) {
                    Picker("Start at:", selection: $vm.start) {
                        ForEach(vm.values, id: \.self) {
                            if $0 < vm.finish {
                                Text(String($0))
                            }
                        }
                    }
                    Picker("Finish at:", selection: $vm.finish) {
                        ForEach(vm.values, id: \.self) {
                            if $0 > vm.start {
                                Text(String($0))
                            }
                        }
                    }
                }
                
                Section(header: Text("Optional run")) {
                    Toggle("Optional run active", isOn: $vm.optRunActive.animation())
                    if vm.optRunActive {
                        Picker("Start at:", selection: $vm.optStart) {
                            ForEach(vm.values, id: \.self) {
                                if $0 < vm.optFinish {
                                    Text(String($0))
                                }
                            }
                        }
                        Picker("Finish at:", selection: $vm.optFinish) {
                            ForEach(vm.values, id: \.self) {
                                if $0 > vm.optStart {
                                    Text(String($0))
                                }
                            }
                        }
                    }
                }
                
                Section(header: Text("Units (per hour)")) {
                    Picker("Units: ", selection: $vm.unit) {
                        Text("KM/H")
                            .tag(Unit.kph)
                        Text("M/H")
                            .tag(Unit.mph)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Section(header: Text("About AccelerationX"), footer: aboutText()) {
                    
                }
            }
            .navigationTitle("Settings")
        }
    }
    
    func aboutText() -> some View {
        VStack {
            Text("Read [Privacy Policy](https://github.com/igorlopatka/Acceleration/blob/master/AccelerationX%20-%20Privacy%20Policy.md), or learn more about developer that created this app: [About Me](https://github.com/igorlopatka).")
        }
    }
    struct SetingsView_Previews: PreviewProvider {
        static var previews: some View {
            SettingsView(vm: RunViewModel())
        }
    }
}
