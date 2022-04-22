//
//  DetailsView.swift
//  Acceleration
//
//  Created by Igor Łopatka on 12/04/2022.
//

import SwiftUI
import MapKit


struct DetailsView: View {
    
    let run: Run
    
    @State private var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.5, longitude: -0.12), span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
    
    var body: some View {
        VStack {
            Map(coordinateRegion: $mapRegion)
                .frame(height: 300)
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

