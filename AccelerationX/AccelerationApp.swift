//
//  AccelerationApp.swift
//  Acceleration
//
//  Created by Igor Łopatka on 20/02/2022.
//

import SwiftUI

@main
struct AccelerationApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var data = DataManager()
    
    init() {
        UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = .systemPink

    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, data.container.viewContext)
        }
    }
}
