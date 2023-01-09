//
//  SettingsView.swift
//  Acceleration
//
//  Created by Igor Łopatka on 14/03/2022.
//

import SwiftUI

struct SettingsView: View {
    
    @ObservedObject var range: RangeManager
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("First run")) {
                    Picker("Start at:", selection: $range.start) {
                        ForEach(range.values, id: \.self) {
                            Text(String($0))
                        }
                    }
                    Picker("Finish at:", selection: $range.finish) {
                        ForEach(range.values, id: \.self) {
                            Text(String($0))
                        }
                    }
                }
                
                Section(header: Text("Optional run")) {
                    Toggle("Optional run active", isOn: $range.optRunActive.animation())
                    if range.optRunActive {
                        Picker("Start at:", selection: $range.optStart) {
                            ForEach(range.values, id: \.self) {
                                Text(String($0))
                            }
                        }
                        Picker("Finish at:", selection: $range.optFinish) {
                            ForEach(range.values, id: \.self) {
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
        SettingsView(range: RangeManager())
    }
}
