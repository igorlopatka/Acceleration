//
//  HistoryView.swift
//  Acceleration
//
//  Created by Igor Łopatka on 14/03/2022.
//

import SwiftUI

struct HistoryView: View {
    
    @Environment(\.managedObjectContext) var context
    @FetchRequest(sortDescriptors: [
        SortDescriptor(\.title)
    ]) var runs: FetchedResults<Run>
        
    var body: some View {
        NavigationView {
            List {
                ForEach(runs) { run in
                    NavigationLink {
                        DetailsView(run: run)
                    } label: {
                        VStack(alignment: .leading) {
                            Text(run.title ?? "No title")
                                .font(.headline)
                        }
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
            offsets.map { runs[$0] }.forEach(context.delete)

            do {
                try context.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct RunDetailsView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
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
