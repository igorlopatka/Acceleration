//
//  SettingsView.swift
//  Acceleration
//
//  Created by Igor Łopatka on 14/03/2022.
//

import SwiftUI

struct SettingsView: View {
    
    @ObservedObject var settings: SettingsManager
    
    var unitSelected = SettingsManager.Units.self
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Units (per hour)")) {
                    Picker("Units: ", selection: $settings.unit) {
                        Text("Kilometers").tag(unitSelected.kilometers)
                        Text("Miles").tag(unitSelected.miles)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .onChange(of: settings.unit) { newValue in
                        settings.updateUnits(unit: settings.unit)
                    }
                }
                Section(header: Text("First run")) {
                    Picker("Start at:", selection: $settings.startRange) {
                        ForEach(settings.values, id: \.self) {
                            Text(String($0))
                        }
                    }
                    Picker("Finish at:", selection: $settings.finishRange) {
                        ForEach(settings.values, id: \.self) {
                            Text(String($0))
                        }
                    }
                }
                
                Section(header: Text("Optional run")) {
                    Toggle("Optional run active", isOn: $settings.optionalRunIsActive.animation())
                    if settings.optionalRunIsActive {
                        Picker("Start at:", selection: $settings.optionalStartRange) {
                            ForEach(settings.values, id: \.self) {
                                Text(String($0))
                            }
                        }
                        Picker("Finish at:", selection: $settings.optionalFinishRange) {
                            ForEach(settings.values, id: \.self) {
                                Text(String($0))
                            }
                        }
                    }
                }
                .navigationTitle("Settings")
            }
        }
    }
}


struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(settings: SettingsManager())
    }
}
