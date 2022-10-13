//
//  DetailsView.swift
//  Acceleration
//
//  Created by Igor Łopatka on 12/04/2022.
//

import SwiftUI

struct DetailsView: View {
    
    let run: Run
    
    var body: some View {
        VStack {
            HStack {
                VStack {
                    Text(run.title ?? "No title")
                        .padding(20)
                        .font(.largeTitle)
                    Text("\(String(run.start)) - \(String(run.finish))")
                    Text(String(format: "%.2f", run.time) + " sec")
                    Text("Units: " + (run.unit ?? "no unit"))
                }
                Spacer()
            }
            Spacer()
        }
    }
}

