//
//  SettingsView.swift
//  Acceleration
//
//  Created by Igor Łopatka on 27/02/2023.
//

import SwiftUI

struct SettingsView: View {
    
    @ObservedObject var vm: RunViewModel
    
    var unitSelected: String {
        switch vm.unit.unit {
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
                    Picker("Start at:", selection: $vm.range.start) {
                        ForEach(vm.range.values, id: \.self) {
                            Text(String($0))
                        }
                    }
                    Picker("Finish at:", selection: $vm.range.finish) {
                        ForEach(vm.range.values, id: \.self) {
                            Text(String($0))
                        }
                    }
                }
                
                Section(header: Text("Optional run")) {
                    Toggle("Optional run active", isOn: $vm.range.optRunActive.animation())
                    if vm.range.optRunActive {
                        Picker("Start at:", selection: $vm.range.optStart) {
                            ForEach(vm.range.values, id: \.self) {
                                Text(String($0))
                            }
                        }
                        Picker("Finish at:", selection: $vm.range.optFinish) {
                            ForEach(vm.range.values, id: \.self) {
                                Text(String($0))
                            }
                        }
                    }
                }
                
                Section(header: Text("Units (per hour)")) {
                    Picker("Units: ", selection: $vm.unit.unit) {
                        Text("KM/H")
                            .tag(Unit.kph)
                        Text("M/H")
                            .tag(Unit.mph)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
            }
            .navigationTitle("Settings")
        }
    }
}

//    struct SettingsView_Previews: PreviewProvider {
//        static var previews: some View {
//            SettingsView(vm: RunViewModel())
//        }
//    }

