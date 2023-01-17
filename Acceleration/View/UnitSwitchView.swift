//
//  UnitSwitchView.swift
//  Acceleration
//
//  Created by Igor Łopatka on 14/11/2022.
//

import SwiftUI

struct UnitSwitchView: View {
    
    @ObservedObject var unit: UnitManager

    var body: some View {
        HStack {
            Button {
                unit.unit = .kph
            } label: {
                switch unit.unit {
                case .kph:
                    UnitSymbolView(symbolName: "kph.circle.fill")
                case .mph:
                    UnitSymbolView(symbolName: "kph.circle")
                }
            }
            Button {
                unit.unit = .mph
            } label: {
                switch unit.unit {
                case .kph:
                    UnitSymbolView(symbolName: "mph.circle")
                case .mph:
                    UnitSymbolView(symbolName: "mph.circle.fill")

                }
            }
        }
        .padding()
    }
}
