//
//  UnitSwitchView.swift
//  Acceleration
//
//  Created by Igor Łopatka on 14/11/2022.
//

import SwiftUI

struct UnitSwitchView: View {

    @Binding var unit: Unit
    var isActive: Bool

    var body: some View {
        HStack(spacing: 0) {
            ForEach([Unit.kph, Unit.mph], id: \.self) { u in
                Button {
                    unit = u
                } label: {
                    Text(u == .kph ? "KPH" : "MPH")
                        .font(.system(size: 12, weight: .semibold))
                        .tracking(1)
                        .foregroundStyle(unit == u ? Color.black : Color.secondary)
                        .frame(width: 48, height: 30)
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(unit == u ? Color.white : Color.clear)
                        )
                }
                .buttonStyle(.plain)
            }
        }
        .padding(3)
        .background(Color(white: 0.2))
        .cornerRadius(18)
        .disabled(isActive)
        .opacity(isActive ? 0.4 : 1.0)
        .animation(.easeInOut(duration: 0.15), value: unit)
    }
}
