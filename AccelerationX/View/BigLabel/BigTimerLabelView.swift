//
//  TimerBigLabelView.swift
//  Acceleration
//
//  Created by Igor Łopatka on 17/01/2023.
//

import SwiftUI

struct BigTimerLabelView: View {
    
    @ObservedObject var timer: TimerManager
    @ObservedObject var optionalTimer: TimerManager
    
    var body: some View {
        HStack {
            if optionalTimer.mode == .running {
                Text(String(format: "%.1f", optionalTimer.counter))
                    .font(.custom("VCR OSD Mono", size: 100))
            } else {
                Text(String(format: "%.1f", timer.counter))
                    .font(.custom("VCR OSD Mono", size: 100))
            }
            
            Text("sec")
                .font(.custom("VCR OSD Mono", size: 30))
                .padding(.top, 70)
        }
    }
}

//struct TimerBigLabelView_Previews: PreviewProvider {
//    static var previews: some View {
//        TimerBigLabelView()
//    }
//}
