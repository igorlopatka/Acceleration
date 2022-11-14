//
//  UnitSwitchView.swift
//  Acceleration
//
//  Created by Igor Łopatka on 14/11/2022.
//

import SwiftUI

struct UnitSwitchView: View {
    
    @State private var unit = Unit.kph
    
    
    
    var body: some View {
        HStack {
            Button {
                unit = .kph
            } label: {
                switch unit {
                case .kph:
                    Image(systemName: "kph.circle.fill")
                case .mph:
                    Image(systemName: "kph.circle")
                }
            }
            Button {
                unit = .mph
            } label: {
                switch unit {
                case .kph:
                    Image(systemName: "mph.circle")
                case .mph:
                    Image(systemName: "mph.circle.fill")
                }
            }
        }
        .padding()
    }
}

struct UnitSwitchView_Previews: PreviewProvider {
    static var previews: some View {
        UnitSwitchView()
    }
}
