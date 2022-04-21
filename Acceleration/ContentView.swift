//
//  ContentView.swift
//  Acceleration
//
//  Created by Igor Łopatka on 20/02/2022.
//

import SwiftUI
import CoreData

struct ContentView: View {

    @Environment(\.managedObjectContext) var context
    @FetchRequest(sortDescriptors: [
        SortDescriptor(\.title)
    ]) var runs: FetchedResults<Run>
    
    @StateObject var settings = Settings()
    
    var body: some View {
        TabView {
            RunView(settings: settings)
                .tabItem {
                    Image(systemName: "car")
                    Text("Run")
                }
            
            HistoryView()
                .tabItem {
                    Image(systemName: "clock")
                    Text("History")
                }
            
            SettingsView(settings: settings)
                .tabItem {
                    Image(systemName: "gearshape")
                    Text("Settings")
                }
        }
        .accentColor(.pink)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
