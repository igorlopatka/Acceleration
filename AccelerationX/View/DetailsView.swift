//
//  DetailsView.swift
//  Acceleration
//
//  Created by Igor Łopatka on 12/04/2022.
//

import SwiftUI

struct DetailsView: View {

    let run: Run

    var body: some View {
        ScrollView {
            VStack(spacing: 14) {

                // ── Header card ───────────────────────────────────────────────
                VStack(spacing: 6) {
                    Text(run.title ?? "Untitled Run")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)

                    if let ts = run.timestamp {
                        Text(ts, style: .date)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 22)
                .padding(.horizontal, 20)
                .background(Color(white: 0.10))
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color(white: 0.20), lineWidth: 0.5)
                )

                // ── Primary timer card ────────────────────────────────────────
                DetailRunCard(
                    label: "TIMER 1",
                    start: Int(run.start),
                    finish: Int(run.finish),
                    time: run.time,
                    unit: run.unit ?? "kmh"
                )

                // ── Optional timer card ───────────────────────────────────────
                if run.optionalRun {
                    DetailRunCard(
                        label: "TIMER 2",
                        start: Int(run.optionalStart),
                        finish: Int(run.optionalFinish),
                        time: run.optionalTime,
                        unit: run.unit ?? "kmh"
                    )
                }
            }
            .padding(16)
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(white: 0.06).ignoresSafeArea())
    }
}

// ── Detail Run Card ───────────────────────────────────────────────────────────

private struct DetailRunCard: View {
    let label: String
    let start: Int
    let finish: Int
    let time: Double
    let unit: String

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {

            // Label
            Text(label)
                .font(.system(size: 11, weight: .semibold))
                .foregroundStyle(.secondary)
                .tracking(3)

            // Time result - hero display
            HStack(alignment: .bottom, spacing: 0) {
                Text(String(format: "%.2f", time))
                    .font(.custom("VCR OSD Mono", size: 52))
                    .foregroundStyle(.white)
                    .shadow(color: Color.pink.opacity(0.25), radius: 10)

                Text(" sec")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(Color(white: 0.4))
                    .padding(.bottom, 8)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)

            Divider()
                .background(Color(white: 0.2))

            // Range row
            HStack {
                VStack(alignment: .leading, spacing: 3) {
                    Text("RANGE")
                        .font(.system(size: 9, weight: .semibold))
                        .foregroundStyle(Color(white: 0.35))
                        .tracking(2)
                    Text("\(start) → \(finish) \(unit)")
                        .font(.system(size: 16, weight: .semibold, design: .monospaced))
                        .foregroundStyle(.pink)
                }

                Spacer()

                // Speed delta badge
                VStack(alignment: .trailing, spacing: 3) {
                    Text("DELTA")
                        .font(.system(size: 9, weight: .semibold))
                        .foregroundStyle(Color(white: 0.35))
                        .tracking(2)
                    Text("\(finish - start) \(unit)")
                        .font(.system(size: 16, weight: .semibold, design: .monospaced))
                        .foregroundStyle(Color(white: 0.75))
                }
            }
        }
        .padding(20)
        .background(Color(white: 0.10))
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.pink.opacity(0.22), lineWidth: 0.5)
        )
    }
}
