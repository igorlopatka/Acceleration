//
//  RunRowView.swift
//  Acceleration
//
//  Created by Igor Łopatka on 11/01/2023.
//

import SwiftUI

struct RunRowView: View {
    
    @ObservedObject var range: RunRange
    
    var body: some View {
        HStack {
            Picker("Start at:", selection: $range.start) {
                ForEach(range.values, id: \.self) {
                    if $0 < range.finish {
                        Text(String($0))
                    }
                    
                }
            }
            .tint(.pink)
            Text( " - ")
            Picker("Finish at:", selection: $range.finish) {
                ForEach(range.values, id: \.self) {
                    if $0 > range.start {
                        Text(String($0))
                    }
                }
            }
            .tint(.pink)
        }
    }
}

struct RunRowView_Previews: PreviewProvider {
    static var previews: some View {
        RunRowView(range: RunRange())
    }
}
