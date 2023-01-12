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
    
    @StateObject var locationController = LocationManager()
    @StateObject var timer = TimerManager()
    @StateObject var optionalTimer = TimerManager()
    @StateObject var range = RangeManager()

    @State private var showAlert = false
    
    @State private var unit = Unit.kph
    @State private var unitsMultiplier = 3.6
    @State private var unitsTitle = "kmh"
    
    private var speedInUnits: Double {
        let inUnits = locationController.speed * unitsMultiplier
        return inUnits
    }
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    timer.reset()
                    optionalTimer.reset()
                }) {
                    Image(systemName: "arrow.counterclockwise")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                        .foregroundColor(.primary)
                        .padding()
                }
                Spacer()
                UnitSwitchView(unit: $unit)
                    .onChange(of: unit) { _ in
                        updateUnits(unit: unit)
                    }
                Spacer()
                
                Image("signal")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
                    .foregroundColor(updateSignalColor(signal: locationController.gpsSignalQuality))
                    .padding()
            }
            
            Spacer()
            
            VStack {
                HStack {
                    Text(String(format: "%.0f", speedInUnits))
                        .font(.custom("VCR OSD Mono", size: 100))
                    Text("\(unitsTitle)")
                        .font(.custom("VCR OSD Mono", size: 30))
                        .padding(.top, 70)
                }
                HStack {
                    if optionalTimer.mode == .running {
                        Text(String(format: "%.1f", optionalTimer.counter))
                            .font(.custom("VCR OSD Mono", size: 100))
                    } else {
                        Text(String(format: "%.1f", timer.counter))
                            .font(.custom("VCR OSD Mono", size: 100))
                    }
                    
                    Text("sec")
                        .font(.custom("VCR OSD Mono", size: 30))
                        .padding(.top, 70)
                }
            }
            .padding()
            
            Spacer()
                RunRowListView(range: range, timer: timer, optTimer: optionalTimer)
            Spacer()
            Button {
                showAlert = true
            } label: {
                Text("SAVE RUN")
                    .foregroundColor(.white)
                    .bold()
            }
            .frame(width: 130, height: 40)
            .background(.pink)
            .cornerRadius(50)
            .padding(.bottom)
            .buttonStyle(.plain)
        
            Spacer()
        }
        .onAppear {
            if locationController.authorizationStatus == .notDetermined {
                locationController.requestPermission()
            }
        }
        .onChange(of: speedInUnits, perform: { newValue in
            let start = Double(range.start)
            let finish = Double(range.finish)
            
            switch newValue {
            case start...finish:
                timer.start()
            default:
                timer.pause()
            }
            
            if range.optRunActive {
                let optStart = Double(range.optStart)
                let optFinish = Double(range.optFinish)
                
                switch newValue {
                case optStart...optFinish:
                    optionalTimer.start()
                default:
                    optionalTimer.pause()
                }
                
            }
        })
        .alert(isPresented: $showAlert,
               TextAlert(title: "SAVE RUN",
                         message: "",
                         keyboardType: .default) { result in
            if let text = result {
                addRun(title: text)
            } else {}
        })
    }
    
    private func updateSignalColor(signal: Signal) -> Color {
        switch signal {
        case .good:
            return .green
        case .mediocre:
            return .yellow
        case .weak:
            return .red
        case .none:
            return .black
        }
    }
    
    private func updateUnits(unit: Unit) {
        switch unit {
        case .kph:
            unitsMultiplier = 3.6
            unitsTitle = "kmh"
        case .mph:
            unitsMultiplier = 2.2369
            unitsTitle = "mph"
        }
    }
    
    private func addRun(title: String) {
        withAnimation {
            let newRun = Run(context: context)
            newRun.timestamp = Date()
            newRun.id = UUID()
            newRun.title = title
            newRun.start = Int16(range.start)
            newRun.finish = Int16(range.finish)
            newRun.time = timer.counter
            newRun.unit = unitsTitle
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
        RunView()
    }
}
