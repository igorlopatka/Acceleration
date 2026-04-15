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
    @StateObject var vm = RunViewModel()

    var body: some View {
        TabView {
            RunView(vm: vm)
                .tabItem {
                    Image(systemName: "gauge.with.needle.fill")
                    Text("Run")
                }

            HistoryView()
                .tabItem {
                    Image(systemName: "clock.arrow.circlepath")
                    Text("History")
                }

            SettingsView(vm: vm)
                .tabItem {
                    Image(systemName: "slider.horizontal.3")
                    Text("Settings")
                }
        }
        .tint(.pink)
        .preferredColorScheme(.dark)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
