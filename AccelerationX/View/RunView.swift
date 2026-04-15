//
//  RunView.swift
//  Acceleration
//
//  Created by Igor Łopatka on 14/03/2022.
//

import SwiftUI

struct RunView: View {

    @Environment(\.managedObjectContext) var context

    @ObservedObject var vm: RunViewModel

    @State private var showAlert = false
    @State private var title = ""

    var body: some View {
        ZStack {
            Color(white: 0.06).ignoresSafeArea()

            VStack(spacing: 0) {

                // ── TOP BAR ──────────────────────────────────────────────────
                topBar
                    .padding(.horizontal, 20)
                    .padding(.top, 16)

                Spacer()

                // ── SPEED GAUGE ───────────────────────────────────────────────
                ZStack {
                    speedArcGauge
                    speedContent
                    if vm.runActive {
                        activeRing
                    }
                }
                .frame(width: 280, height: 280)

                statusBadge
                    .padding(.top, 10)

                peakSpeedStat
                    .padding(.top, 6)

                Spacer()

                // ── TIMER DISPLAY ─────────────────────────────────────────────
                BigTimerLabelView(timer: vm.timer, optionalTimer: vm.optionalTimer)

                Spacer()

                // ── RANGE CARD ────────────────────────────────────────────────
                RunRowListView(vm: vm, timer: vm.timer, optTimer: vm.optionalTimer)
                    .padding(.horizontal, 20)

                Spacer(minLength: 8)

                // ── SAVE BUTTON ───────────────────────────────────────────────
                saveButton
                    .padding(.horizontal, 20)
                    .padding(.bottom, 12)

                // ── AD BANNER ─────────────────────────────────────────────────
                BannerView()
                    .frame(height: 60)
            }
        }
        .onAppear {
            vm.requestPermission()
        }
        .onDisappear {
            vm.resetTimers()
            vm.runFinished = false
        }
        .onChange(of: vm.speedInUnits) { newValue in
            handleSpeedChange(newValue)
        }
        .onChange(of: vm.timer.mode) { _ in
            vm.updateRunState()
        }
        .onChange(of: vm.optionalTimer.mode) { _ in
            vm.updateRunState()
        }
        .alert("Save current run", isPresented: $showAlert) {
            TextField("Title", text: $title)
            Button("Save") { addRun(title: title) }
            Button("Cancel", role: .cancel) { showAlert = false }
        } message: {}
    }

    // MARK: - Top Bar

    private var topBar: some View {
        HStack {
            signalPill

            Spacer()

            UnitSwitchView(unit: $vm.unit, isActive: vm.runActive)
                .onChange(of: vm.unit) { _ in vm.updateUnits() }

            Spacer()

            Button {
                vm.resetTimers()
                vm.runFinished = false
            } label: {
                Image(systemName: "arrow.counterclockwise.circle.fill")
                    .font(.system(size: 32))
                    .foregroundStyle(vm.runActive ? Color(white: 0.25) : Color(white: 0.85))
            }
            .disabled(vm.runActive)
            .buttonStyle(.plain)
        }
    }

    // MARK: - Speed Arc Gauge

    private var speedArcGauge: some View {
        let finish = Double(max(vm.finish, 1))
        let progress = min(vm.speedInUnits / finish, 1.0) * 0.75
        let startFrac = Double(vm.start) / finish * 0.75
        let inRange = vm.speedInUnits >= Double(vm.start)

        return ZStack {
            // Background track
            Circle()
                .trim(from: 0.0, to: 0.75)
                .stroke(Color(white: 0.13), style: StrokeStyle(lineWidth: 10, lineCap: .round))
                .rotationEffect(.degrees(225))

            // Target range highlight
            if startFrac < 0.75 {
                Circle()
                    .trim(from: CGFloat(startFrac), to: 0.75)
                    .stroke(Color.pink.opacity(0.12), style: StrokeStyle(lineWidth: 10, lineCap: .round))
                    .rotationEffect(.degrees(225))
            }

            // Speed fill
            if progress > 0 {
                Circle()
                    .trim(from: 0.0, to: CGFloat(progress))
                    .stroke(
                        LinearGradient(
                            colors: inRange
                                ? [Color(red: 1.0, green: 0.2, blue: 0.45), .pink]
                                : [Color(white: 0.28), Color(white: 0.48)],
                            startPoint: .leading,
                            endPoint: .trailing
                        ),
                        style: StrokeStyle(lineWidth: 10, lineCap: .round)
                    )
                    .rotationEffect(.degrees(225))
                    .animation(.easeOut(duration: 0.08), value: vm.speedInUnits)

                // Tip glow when in range
                if inRange {
                    Circle()
                        .trim(from: CGFloat(max(progress - 0.05, 0.0)), to: CGFloat(progress))
                        .stroke(Color.pink.opacity(0.55), style: StrokeStyle(lineWidth: 14, lineCap: .round))
                        .rotationEffect(.degrees(225))
                        .blur(radius: 7)
                        .animation(.easeOut(duration: 0.08), value: vm.speedInUnits)
                }
            }
        }
    }

    // MARK: - Active Ring

    private var activeRing: some View {
        Circle()
            .stroke(Color.pink.opacity(0.18), lineWidth: 1.5)
            .frame(width: 300, height: 300)
    }

    // MARK: - Speed Content

    private var speedContent: some View {
        VStack(spacing: 0) {
            Text(String(format: "%.0f", vm.speedInUnits))
                .font(.custom("VCR OSD Mono", size: 82))
                .foregroundStyle(.white)
                .contentTransition(.numericText())
                .animation(.easeOut(duration: 0.1), value: vm.speedInUnits)

            Text(vm.title.uppercased())
                .font(.system(size: 11, weight: .semibold))
                .foregroundStyle(Color(white: 0.38))
                .tracking(5)
        }
        .offset(y: -6)
    }

    // MARK: - Status Badge

    @ViewBuilder
    private var statusBadge: some View {
        if vm.runActive {
            statusLabel("● ACTIVE", color: .pink)
        } else if vm.runFinished {
            statusLabel("✓ FINISHED", color: Color(red: 0.3, green: 0.9, blue: 0.5))
        } else {
            statusLabel("READY", color: Color(white: 0.38))
        }
    }

    private func statusLabel(_ text: String, color: Color) -> some View {
        Text(text)
            .font(.system(size: 11, weight: .semibold))
            .foregroundStyle(color)
            .tracking(3)
    }

    // MARK: - Peak Speed Stat

    @ViewBuilder
    private var peakSpeedStat: some View {
        if vm.peakSpeed > 0 {
            Text("PEAK  \(String(format: "%.0f", vm.peakSpeed)) \(vm.title.uppercased())")
                .font(.system(size: 10, weight: .semibold, design: .monospaced))
                .foregroundStyle(Color(white: 0.38))
                .tracking(2)
        } else {
            // Reserve space so layout doesn't shift when peak appears
            Text(" ")
                .font(.system(size: 10))
        }
    }

    // MARK: - GPS Signal Pill

    private var signalPill: some View {
        let color: Color = {
            switch vm.signalQuality {
            case .good:     return .green
            case .mediocre: return .yellow
            case .weak:     return .red
            case .none:     return Color(white: 0.35)
            }
        }()

        return HStack(spacing: 5) {
            Circle()
                .fill(color)
                .frame(width: 7, height: 7)
                .shadow(color: color.opacity(0.9), radius: 3)
            Text(vm.signalQuality == .none ? "NO GPS" : "GPS")
                .font(.system(size: 11, weight: .semibold))
                .foregroundStyle(Color(white: 0.5))
                .tracking(2)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(Color(white: 0.12))
        .cornerRadius(20)
    }

    // MARK: - Save Button

    private var saveButton: some View {
        let canSave = !vm.runActive && vm.runFinished
        return Button {
            showAlert = true
        } label: {
            Text("SAVE RUN")
                .font(.system(size: 15, weight: .bold))
                .tracking(2)
                .foregroundStyle(canSave ? .white : Color(white: 0.32))
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .background(canSave ? Color.pink : Color(white: 0.12))
                .cornerRadius(16)
        }
        .disabled(!canSave)
        .buttonStyle(.plain)
        .animation(.easeInOut(duration: 0.2), value: vm.runFinished)
    }

    // MARK: - Speed Change Handler

    private func handleSpeedChange(_ newValue: Double) {
        let start = Double(vm.start)
        let finish = Double(vm.finish)

        switch newValue {
        case start...finish:
            vm.timer.start()
        default:
            vm.timer.pause()
            if vm.timer.counter != 0 { vm.runFinished = true }
        }

        if vm.optRunActive {
            let optStart = Double(vm.optStart)
            let optFinish = Double(vm.optFinish)
            switch newValue {
            case optStart...optFinish:
                vm.optionalTimer.start()
            default:
                vm.optionalTimer.pause()
                if vm.timer.counter != 0 { vm.runFinished = true }
            }
        }
    }

    // MARK: - CoreData Save

    private func addRun(title: String) {
        withAnimation {
            let newRun = Run(context: context)
            newRun.timestamp = Date()
            newRun.id = UUID()
            newRun.title = title
            newRun.start = Int16(vm.start)
            newRun.finish = Int16(vm.finish)
            newRun.optionalRun = vm.optRunActive
            if newRun.optionalRun {
                newRun.optionalStart = Int16(vm.optStart)
                newRun.optionalFinish = Int16(vm.optFinish)
                newRun.optionalTime = vm.optionalTimer.counter
            }
            newRun.time = vm.timer.counter
            newRun.unit = vm.title
            do {
                try context.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct RunView_Previews: PreviewProvider {
    static var previews: some View {
        RunView(vm: RunViewModel())
            .preferredColorScheme(.dark)
    }
}
