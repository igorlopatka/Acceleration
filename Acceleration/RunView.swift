//
//  RunView.swift
//  Acceleration
//
//  Created by Igor Łopatka on 14/03/2022.
//

import SwiftUI

struct RunView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Run.timestamp, ascending: true)],
        animation: .default)
    private var runs: FetchedResults<Run>
    

    
    var body: some View {
        NavigationView {
            Text("Run View")
                .navigationTitle("Run")
        }
    }
    
    private func addItem() {
        withAnimation {
            let newItem = Run(context: viewContext)
            newItem.timestamp = Date()
            newItem.id = UUID()
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
}



struct RunView_Previews: PreviewProvider {
    static var previews: some View {
        RunView()
    }
}
