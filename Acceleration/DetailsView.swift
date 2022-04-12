//
//  DetailsView.swift
//  Acceleration
//
//  Created by Igor Łopatka on 12/04/2022.
//

import SwiftUI
import MapKit


struct DetailsView: View {
    
    @State private var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.5, longitude: -0.12), span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
    
    var body: some View {
        VStack {
            Map(coordinateRegion: $mapRegion)
                .frame(width: .infinity, height: 300, alignment: .top)
            HStack {
                Text("Run Title")
                    .padding(20)
                    .font(.largeTitle)
                Spacer()
            }
            Spacer()
        }
    }
}

struct DetailsView_Previews: PreviewProvider {
    static var previews: some View {
        DetailsView()
    }
}
