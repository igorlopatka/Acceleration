//
//  SettingsView.swift
//  Acceleration
//
//  Created by Igor Łopatka on 14/03/2022.
//

import SwiftUI

struct SettingsView: View {
    
@StateObject var settings = Settings()
    
    enum Units {
        case kilometers, miles
    }
        
    var body: some View {
        NavigationView {
            Form {
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
                
                Section(header: Text("Units (per hour)")) {
                    VStack {
                        HStack {
//                            Text("Units: \($settings.unitSelected)")
                            Spacer()
                        }
                        
                        Spacer()
                        Picker("Units: ", selection: $settings.unitsMultiplier) {
                            Text("Kilometers").tag(3.6)
                            Text("Miles").tag(2.2369)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                    
                }
                
                Section(header: Text("Sound")) {
                    Toggle("Play sound at run finish", isOn: $settings.soundIsOn)
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
