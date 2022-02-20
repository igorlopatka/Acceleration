//
//  AccelerationApp.swift
//  Acceleration
//
//  Created by Igor Łopatka on 20/02/2022.
//

import SwiftUI

@main
struct AccelerationApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
