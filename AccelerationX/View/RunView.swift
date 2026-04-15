//
//  RunView.swift
//  Acceleration
//
//  Created by Igor Łopatka on 14/03/2022.
//

import SwiftUI

struct RunView: View {

    @Environment(\.managedObjectContext) var context
    @Environment(\.dismiss) var dismiss

    @ObservedObject var vm: RunViewModel

    @State private var showAlert = false
    @State private var title = ""

    var body: some View {
        ZStack {
            // Full-bleed dark gradient background
            LinearGradient(
                colors: [Color(white: 0.10), Color(white: 0.06)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {

                // ── TOP BAR ──────────────────────────────────────────────
                HStack {
                    // GPS signal pill
                    signalPill

                    Spacer()

                    // KPH / MPH pill toggle
                    UnitSwitchView(unit: $vm.unit, isActive: vm.runActive)
                        .onChange(of: vm.unit) { _ in
                            vm.updateUnits()
                        }

                    Spacer()

                    // Reset button
                    Button {
                        vm.resetTimers()
                    } label: {
                        Image(systemName: "arrow.counterclockwise.circle.fill")
                            .font(.system(size: 32))
                            .foregroundStyle(vm.runActive ? Color(white: 0.35) : .white)
                    }
                    .disabled(vm.runActive)
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)

                Spacer()

                // ── SPEED DISPLAY ─────────────────────────────────────────
                VStack(spacing: 2) {
                    Text(String(format: "%.0f", vm.speedInUnits))
                        .font(.custom("VCR OSD Mono", size: 96))
                        .foregroundStyle(.white)
                        .contentTransition(.numericText())
                        .animation(.easeOut(duration: 0.1), value: vm.speedInUnits)

                    Text(vm.title.uppercased())
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(.secondary)
                        .tracking(6)
                }

                Spacer()

                // ── TIMER DISPLAY ─────────────────────────────────────────
                BigTimerLabelView(timer: vm.timer, optionalTimer: vm.optionalTimer)

                Spacer()

                // ── RANGE CARD ────────────────────────────────────────────
                RunRowListView(vm: vm, timer: vm.timer, optTimer: vm.optionalTimer)
                    .padding(.horizontal, 20)

                Spacer()

                // ── SAVE BUTTON ───────────────────────────────────────────
                Button {
                    showAlert = true
                } label: {
                    Text("SAVE RUN")
                        .font(.system(size: 15, weight: .bold))
                        .tracking(2)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(
                            (vm.runActive || !vm.runFinished)
                                ? Color.pink.opacity(0.25)
                                : Color.pink
                        )
                        .cornerRadius(16)
                }
                .disabled(vm.runActive || !vm.runFinished)
                .padding(.horizontal, 20)
                .padding(.bottom, 14)
                .buttonStyle(.plain)
                .animation(.easeInOut(duration: 0.2), value: vm.runFinished)

                // ── AD BANNER ─────────────────────────────────────────────
                BannerView()
                    .frame(height: 60)
            }
        }
        .onAppear {
            vm.requestPermission()
        }
        .onDisappear {
            vm.resetTimers()
        }
        .onChange(of: vm.speedInUnits, perform: { newValue in
            let start = Double(vm.start)
            let finish = Double(vm.finish)

            switch newValue {
            case start...finish:
                vm.timer.start()
            default:
                vm.timer.pause()
                if vm.timer.counter != 0 {
                    vm.runFinished = true
                }
            }

            if vm.optRunActive {
                let optStart = Double(vm.optStart)
                let optFinish = Double(vm.optFinish)

                switch newValue {
                case optStart...optFinish:
                    vm.optionalTimer.start()
                default:
                    vm.optionalTimer.pause()
                    if vm.timer.counter != 0 {
                        vm.runFinished = true
                    }
                }
            }
        })
        .onChange(of: vm.timer.mode, perform: { _ in
            vm.updateRunState()
        })
        .onChange(of: vm.optionalTimer.mode, perform: { _ in
            vm.updateRunState()
        })
        .alert("Save current run", isPresented: $showAlert, actions: {
            TextField("Title", text: $title)
            Button("Save", action: {
                addRun(title: title)
            })
            Button("Cancel", role: .cancel, action: {
                showAlert = false
            })
        }, message: {})
    }

    // ── GPS SIGNAL PILL ───────────────────────────────────────────────────
    private var signalPill: some View {
        HStack(spacing: 6) {
            Circle()
                .fill(vm.updateSignalColor())
                .frame(width: 8, height: 8)
                .shadow(color: vm.updateSignalColor().opacity(0.6), radius: 4)
            Text(vm.signalQuality == .none ? "NO GPS" : "GPS")
                .font(.system(size: 11, weight: .semibold))
                .foregroundStyle(.secondary)
                .tracking(2)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(Color(white: 0.16))
        .cornerRadius(20)
    }

    // ── CORE DATA SAVE ────────────────────────────────────────────────────
    private func addRun(title: String) {
        withAnimation {
            let newRun = Run(context: context)
            newRun.timestamp = Date()
            newRun.id = UUID()
            newRun.title = title
            newRun.start = Int16(vm.start)
            newRun.finish = Int16(vm.finish)
            newRun.optionalRun = vm.optRunActive
            if newRun.optionalRun == true {
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
