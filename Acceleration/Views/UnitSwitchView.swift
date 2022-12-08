//
//  UnitSwitchView.swift
//  Acceleration
//
//  Created by Igor Łopatka on 14/11/2022.
//

import SwiftUI

struct UnitSwitchView: View {
    
    @Binding var unit: Unit

    var body: some View {
        HStack {
            Button {
                unit = .kph
            } label: {
                switch unit {
                case .kph:
                    UnitSymbolView(symbolName: "kph.circle.fill")
                case .mph:
                    UnitSymbolView(symbolName: "kph.circle")
                }
            }
            Button {
                unit = .mph
            } label: {
                switch unit {
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
