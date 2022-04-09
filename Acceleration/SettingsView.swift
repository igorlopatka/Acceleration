//
//  SettingsView.swift
//  Acceleration
//
//  Created by Igor Łopatka on 14/03/2022.
//

import SwiftUI

struct SettingsView: View {
    
    @State private var startRange = 0
    @State private var finishRange = 100
    @State private var optionalStartRange = 100
    @State private var optionalFinishRange = 200
    @State private var units = Units.kilometers
    @State private var optionalRunIsActive = false
    @State private var soundIsOn = true
    
    let values = [0,20,40,60,80,100,120,140,160,180,200,220,240,260,280,300]
    
    enum Units {
        case kilometers, miles
    }
    
    var unitSelected: String {
        switch units {
        case .kilometers:
            return "Kilometers per hour"
        case .miles:
            return "Miles per hour"
        }
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("First run")) {
                    Picker("Start at:", selection: $startRange) {
                        ForEach(values, id: \.self) {
                            Text(String($0))
                        }
                    }
                    Picker("Finish at:", selection: $finishRange) {
                        ForEach(values, id: \.self) {
                            Text(String($0))
                        }
                    }
                }
                
                Section(header: Text("Optional run")) {
                    Toggle("Optional run active", isOn: $optionalRunIsActive.animation())
                    if optionalRunIsActive {
                        Picker("Start at:", selection: $startRange) {
                            ForEach(values, id: \.self) {
                                Text(String($0))
                            }
                        }
                        Picker("Finish at:", selection: $finishRange) {
                            ForEach(values, id: \.self) {
                                Text(String($0))
                            }
                        }
                    }
                }
                
                Section(header: Text("Units (per hour)")) {
                    VStack {
                        HStack {
                            Text("Units: \(unitSelected)")
                            Spacer()
                        }
                        
                        Spacer()
                        Picker("Units: ", selection: $units) {
                            Text("KM/H")
                                .tag(Units.kilometers)
                            Text("M/H")
                                .tag(Units.miles)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                    
                }
                
                Section(header: Text("Sound")) {
                    Toggle("Play sound at run finish", isOn: $soundIsOn)
                }
                .navigationTitle("Settings")
            }
        }
    }
}


struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
