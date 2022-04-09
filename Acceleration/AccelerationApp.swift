//
//  AccelerationApp.swift
//  Acceleration
//
//  Created by Igor Łopatka on 20/02/2022.
//

import SwiftUI

@main
struct AccelerationApp: App {
    
    @StateObject private var runDataController = DataManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, runDataController.container.viewContext)
        }
    }
}
