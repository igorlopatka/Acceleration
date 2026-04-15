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
            VStack(spacing: 16) {

                // ── Title card ────────────────────────────────────────────
                VStack(spacing: 6) {
                    Text(run.title ?? "Untitled Run")
                        .font(.system(size: 26, weight: .bold))
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)

                    if let ts = run.timestamp {
                        Text(ts, style: .date)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(20)
                .background(Color(white: 0.12))
                .cornerRadius(20)

                // ── Primary timer card ────────────────────────────────────
                DetailRunCard(
                    label: "TIMER 1",
                    start: Int(run.start),
                    finish: Int(run.finish),
                    time: run.time,
                    unit: run.unit ?? "kmh"
                )

                // ── Optional timer card ───────────────────────────────────
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
            .padding(20)
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(red: 0.07, green: 0.07, blue: 0.07).ignoresSafeArea())
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
        VStack(alignment: .leading, spacing: 14) {
            Text(label)
                .font(.system(size: 11, weight: .semibold))
                .foregroundStyle(.secondary)
                .tracking(3)

            HStack(alignment: .bottom) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("RANGE")
                        .font(.system(size: 9, weight: .medium))
                        .foregroundStyle(Color(white: 0.4))
                        .tracking(2)
                    Text("\(start) → \(finish) \(unit)")
                        .font(.system(size: 17, weight: .semibold, design: .monospaced))
                        .foregroundStyle(.pink)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 2) {
                    Text(String(format: "%.2f", time))
                        .font(.custom("VCR OSD Mono", size: 44))
                        .foregroundStyle(.white)
                    Text("seconds")
                        .font(.system(size: 12))
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(20)
        .background(Color(white: 0.12))
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.pink.opacity(0.25), lineWidth: 0.5)
        )
    }
}
