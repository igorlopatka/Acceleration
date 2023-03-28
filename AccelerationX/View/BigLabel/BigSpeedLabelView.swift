//
//  BigSpeedLabelView.swift
//  Acceleration
//
//  Created by Igor Łopatka on 17/01/2023.
//

import SwiftUI

struct BigSpeedLabelView: View {
    
    @ObservedObject var vm: RunViewModel
    
    var body: some View {
        HStack {
            Text(String(format: "%.0f", vm.speedInUnits))
                .font(.custom("VCR OSD Mono", size: 100))
            Text("\(vm.unit.title)")
                .font(.custom("VCR OSD Mono", size: 30))
                .padding(.top, 70)
        }
    }
}

//struct BigSpeedLabelView_Previews: PreviewProvider {
//    static var previews: some View {
//        BigSpeedLabelView()
//    }
//}
