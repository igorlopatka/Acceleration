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
        SortDescriptor(\.timestamp, order: .reverse)
    ]) var runs: FetchedResults<Run>

    var body: some View {
        NavigationStack {
            Group {
                if runs.isEmpty {
                    emptyState
                } else {
                    List {
                        ForEach(runs) { run in
                            NavigationLink {
                                DetailsView(run: run)
                            } label: {
                                RunHistoryRow(run: run)
                            }
                            .listRowBackground(Color(white: 0.12))
                            .listRowSeparatorTint(Color(white: 0.22))
                        }
                        .onDelete(perform: deleteItems)
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                }
            }
            .navigationTitle("History")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                        .tint(.pink)
                }
            }
            .background(Color(red: 0.07, green: 0.07, blue: 0.07))
        }
    }

    private var emptyState: some View {
        VStack(spacing: 14) {
            Image(systemName: "flag.checkered")
                .font(.system(size: 56))
                .foregroundStyle(Color(white: 0.35))
            Text("No Runs Yet")
                .font(.title2.bold())
                .foregroundStyle(.white)
            Text("Complete a run and save it\nto see your results here.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(red: 0.07, green: 0.07, blue: 0.07))
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

// ── History Row ───────────────────────────────────────────────────────────────

private struct RunHistoryRow: View {
    let run: Run

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(run.title ?? "Untitled Run")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(.white)

            HStack {
                Text("\(run.start) → \(run.finish) \(run.unit ?? "")")
                    .font(.system(size: 13, weight: .medium, design: .monospaced))
                    .foregroundStyle(.pink)

                Spacer()

                Text(String(format: "%.2f", run.time) + " sec")
                    .font(.system(size: 13, weight: .bold, design: .monospaced))
                    .foregroundStyle(.white)
            }

            if let ts = run.timestamp {
                Text(ts, style: .date)
                    .font(.system(size: 11))
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 6)
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
            .preferredColorScheme(.dark)
    }
}
