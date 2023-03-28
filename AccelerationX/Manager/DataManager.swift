//
//  RunDataController.swift
//  Acceleration
//
//  Created by Igor Łopatka on 05/04/2022.
//

import CoreData
import Foundation

class DataManager: ObservableObject {
    
    let container = NSPersistentContainer(name: "Acceleration")

    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
    }
}
