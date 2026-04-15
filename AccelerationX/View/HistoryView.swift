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
                            .listRowBackground(Color(white: 0.10))
                            .listRowSeparatorTint(Color(white: 0.18))
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
            .background(Color(white: 0.06))
        }
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "flag.checkered")
                .font(.system(size: 52))
                .foregroundStyle(Color(white: 0.28))
            Text("No Runs Yet")
                .font(.title2.bold())
                .foregroundStyle(.white)
            Text("Complete a run and save it\nto see your results here.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(white: 0.06))
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
        HStack(spacing: 14) {
            // Speed range badge
            VStack(alignment: .center, spacing: 3) {
                Text("\(run.start)")
                    .font(.system(size: 12, weight: .bold, design: .monospaced))
                    .foregroundStyle(.white)
                Image(systemName: "arrow.down")
                    .font(.system(size: 8, weight: .bold))
                    .foregroundStyle(.pink)
                Text("\(run.finish)")
                    .font(.system(size: 12, weight: .bold, design: .monospaced))
                    .foregroundStyle(.white)
            }
            .frame(width: 38)
            .padding(.vertical, 8)
            .background(Color(white: 0.17))
            .cornerRadius(10)

            VStack(alignment: .leading, spacing: 4) {
                Text(run.title ?? "Untitled Run")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.white)

                Text("\(run.start) → \(run.finish) \(run.unit ?? "")")
                    .font(.system(size: 12, weight: .medium, design: .monospaced))
                    .foregroundStyle(.pink)

                if let ts = run.timestamp {
                    Text(ts, style: .date)
                        .font(.system(size: 11))
                        .foregroundStyle(Color(white: 0.38))
                }
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 2) {
                Text(String(format: "%.2f", run.time))
                    .font(.custom("VCR OSD Mono", size: 22))
                    .foregroundStyle(.white)
                Text("sec")
                    .font(.system(size: 11))
                    .foregroundStyle(Color(white: 0.38))
            }
        }
        .padding(.vertical, 8)
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
            .preferredColorScheme(.dark)
    }
}
