//
//  SettingsView.swift
//  Acceleration
//
//  Created by Igor Łopatka on 14/03/2022.
//

import SwiftUI

struct SettingsView: View {
    
    @ObservedObject var settings: RangeManager
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("First run")) {
                    Picker("Start at:", selection: $settings.start) {
                        ForEach(settings.values, id: \.self) {
                            Text(String($0))
                        }
                    }
                    Picker("Finish at:", selection: $settings.finish) {
                        ForEach(settings.values, id: \.self) {
                            Text(String($0))
                        }
                    }
                }
                
                Section(header: Text("Optional run")) {
                    Toggle("Optional run active", isOn: $settings.optRunActive.animation())
                    if settings.optRunActive {
                        Picker("Start at:", selection: $settings.optStart) {
                            ForEach(settings.values, id: \.self) {
                                Text(String($0))
                            }
                        }
                        Picker("Finish at:", selection: $settings.optFinish) {
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
        SettingsView(settings: RangeManager())
    }
}
