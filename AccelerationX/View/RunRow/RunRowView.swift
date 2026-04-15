//
//  RunRowView.swift
//  Acceleration
//
//  Created by Igor Łopatka on 11/01/2023.
//

import SwiftUI

struct RunRowView: View {

    @Binding var start: Int
    @Binding var finish: Int
    @Binding var active: Bool

    let values = [0,20,40,60,80,100,120,140,160,180,200,220,240,260,280,300]

    var body: some View {
        HStack(spacing: 4) {
            Picker("Start at:", selection: $start) {
                ForEach(values, id: \.self) {
                    if $0 < finish {
                        Text(String($0))
                    }
                }
            }
            .disabled(active)
            .tint(.pink)

            Text("→")
                .foregroundStyle(.secondary)
                .font(.system(size: 14, weight: .semibold))

            Picker("Finish at:", selection: $finish) {
                ForEach(values, id: \.self) {
                    if $0 > start {
                        Text(String($0))
                    }
                }
            }
            .disabled(active)
            .tint(.pink)
        }
    }
}
