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
    
    @StateObject var vm = RunViewModel()
    
    var body: some View {
        TabView {
            RunView(vm: vm)
                .tabItem {
                    Image(systemName: "car")
                    Text("Run")
                }
            
            HistoryView()
                .tabItem {
                    Image(systemName: "stopwatch.fill")
                    Text("History")
                }
            SettingsView(vm: vm)
                .tabItem {
                    Image(systemName: "gearshape.2.fill")
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
