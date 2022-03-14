//
//  HistoryView.swift
//  Acceleration
//
//  Created by Igor Łopatka on 14/03/2022.
//

import SwiftUI

struct HistoryView: View {
    
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Run.timestamp, ascending: true)],
        animation: .default)
    
    private var runs: FetchedResults<Run>
    
    var body: some View {
        NavigationView {
            List {
                ForEach(runs) { run in
                    NavigationLink {
                        Text("Item at \(run.timestamp!, formatter: itemFormatter)")
                    } label: {
                        Text(run.timestamp!, formatter: itemFormatter)
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                        .foregroundColor(.pink)
                }
            }
            .navigationTitle("History")
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { runs[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}
