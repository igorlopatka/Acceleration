//
//  UnitSwitchView.swift
//  Acceleration
//
//  Created by Igor Łopatka on 14/11/2022.
//

import SwiftUI

struct UnitSwitchView: View {
    
    @ObservedObject var vm: RunViewModel

    var body: some View {
        HStack {
            Button {
                vm.unit.unit = .kph
            } label: {
                switch vm.unit.unit {
                case .kph:
                    UnitSymbolView(symbolName: "kph.circle.fill")
                case .mph:
                    UnitSymbolView(symbolName: "kph.circle")
                }
            }
            .disabled(vm.runActive)
            Button {
                vm.unit.unit = .mph
            } label: {
                switch vm.unit.unit {
                case .kph:
                    UnitSymbolView(symbolName: "mph.circle")
                case .mph:
                    UnitSymbolView(symbolName: "mph.circle.fill")

                }
            }
            .disabled(vm.runActive)
        }
        .padding()
    }
}
