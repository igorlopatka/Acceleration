//
//  SettingsView.swift
//  Acceleration
//
//  Created by Igor Łopatka on 27/02/2023.
//

import SwiftUI

struct SettingsView: View {

    @ObservedObject var vm: RunViewModel

    var body: some View {
        NavigationStack {
            List {
                // ── Primary timer ─────────────────────────────────────────────
                Section {
                    Picker("Start at:", selection: $vm.start) {
                        ForEach(vm.values, id: \.self) {
                            if $0 < vm.finish { Text(String($0)) }
                        }
                    }
                    .tint(.pink)

                    Picker("Finish at:", selection: $vm.finish) {
                        ForEach(vm.values, id: \.self) {
                            if $0 > vm.start { Text(String($0)) }
                        }
                    }
                    .tint(.pink)
                } header: {
                    sectionHeader("Timer 1")
                }
                .listRowBackground(Color(white: 0.12))

                // ── Optional timer ────────────────────────────────────────────
                Section {
                    Toggle("Enable Timer 2", isOn: $vm.optRunActive.animation())
                        .tint(.pink)

                    if vm.optRunActive {
                        Picker("Start at:", selection: $vm.optStart) {
                            ForEach(vm.values, id: \.self) {
                                if $0 < vm.optFinish { Text(String($0)) }
                            }
                        }
                        .tint(.pink)

                        Picker("Finish at:", selection: $vm.optFinish) {
                            ForEach(vm.values, id: \.self) {
                                if $0 > vm.optStart { Text(String($0)) }
                            }
                        }
                        .tint(.pink)
                    }
                } header: {
                    sectionHeader("Timer 2")
                }
                .listRowBackground(Color(white: 0.12))

                // ── Units ─────────────────────────────────────────────────────
                Section {
                    Picker("Units", selection: $vm.unit) {
                        Text("KM/H").tag(Unit.kph)
                        Text("MPH").tag(Unit.mph)
                    }
                    .pickerStyle(.segmented)
                    .onChange(of: vm.unit) { _ in vm.updateUnits() }
                } header: {
                    sectionHeader("Speed Unit")
                }
                .listRowBackground(Color(white: 0.12))

                // ── About ─────────────────────────────────────────────────────
                Section {
                    Link(destination: URL(string: "https://github.com/igorlopatka/Acceleration/blob/master/AccelerationX%20-%20Privacy%20Policy.md")!) {
                        Label("Privacy Policy", systemImage: "hand.raised.fill")
                            .foregroundStyle(.pink)
                    }
                    Link(destination: URL(string: "https://github.com/igorlopatka/Acceleration/blob/master/README.md")!) {
                        Label("GitHub Repository", systemImage: "chevron.left.forwardslash.chevron.right")
                            .foregroundStyle(.pink)
                    }
                    Link(destination: URL(string: "https://github.com/igorlopatka")!) {
                        Label("About the Developer", systemImage: "person.fill")
                            .foregroundStyle(.pink)
                    }
                } header: {
                    sectionHeader("About AccelerationX")
                }
                .listRowBackground(Color(white: 0.12))
            }
            .listRowSeparatorTint(Color(white: 0.20))
            .scrollContentBackground(.hidden)
            .background(Color(white: 0.06))
            .navigationTitle("Settings")
        }
    }

    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(.system(size: 11, weight: .semibold))
            .foregroundStyle(Color(white: 0.45))
            .tracking(2)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(vm: RunViewModel())
            .preferredColorScheme(.dark)
    }
}
