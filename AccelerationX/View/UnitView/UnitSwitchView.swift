//
//  UnitSwitchView.swift
//  Acceleration
//
//  Created by Igor Łopatka on 14/11/2022.
//

import SwiftUI

struct UnitSwitchView: View {
    
    @Binding var isActive: Bool
    @ObservedObject var unit: UnitManager

    var body: some View {
        HStack {
            Button {
                unit.unit = .kph
            } label: {
                switch unit.unit {
                case .kph:
                    UnitSymbolView(isActive: $isActive, symbolName: "kph.circle.fill")
                case .mph:
                    UnitSymbolView(isActive: $isActive, symbolName: "kph.circle")
                }
            }
            Button {
                unit.unit = .mph
            } label: {
                switch unit.unit {
                case .kph:
                    UnitSymbolView(isActive: $isActive, symbolName: "mph.circle")
                case .mph:
                    UnitSymbolView(isActive: $isActive, symbolName: "mph.circle.fill")

                }
            }
        }
        .disabled(isActive)
        .padding()
    }
}
