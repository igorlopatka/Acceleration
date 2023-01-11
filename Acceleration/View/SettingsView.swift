//
//  SettingsView.swift
//  Acceleration
//
//  Created by Igor Łopatka on 14/03/2022.
//

import SwiftUI

struct SettingsView: View {
    
    @ObservedObject var range: RangeManager
    @State private var optRunActive = false
    
    var body: some View {
        VStack {
            HStack {
                RunRowView(range: RunRange())
                Button {
                    optRunActive = true
                } label: {
                    Image(systemName: "plus.circle")
                        .tint(.pink)
                }
            }
            if optRunActive {
                RunRowView(range: RunRange())
            }

        }
    }
}


struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(range: RangeManager())
    }
}
