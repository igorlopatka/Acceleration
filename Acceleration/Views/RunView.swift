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
    @ObservedObject var settings: SettingsManager

    @State private var showAlert = false
    
    // roboczo
    @State private var unit = Unit.kph
    
    var speedInUnits: Double {
        let speedMS = locationController.lastSeenLocation?.speed ?? 0
        let speedInUnits = Double(speedMS) * settings.unitsMultiplier
        
        if speedInUnits <= 2 {
            return 0
        } else {
            return speedInUnits
        }
    }
    
    var gpsAccuracy: Double {
        let accuracy =  locationController.lastSeenLocation?.horizontalAccuracy
        return Double(accuracy ?? 0)
    }
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    timer.reset()
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
                VStack {
                    HStack {
                        
                        // Make it better in the future!
                        
                        Text("GPS SIGNAL")
                        if (gpsAccuracy < 0) {
                            Image(systemName: "network")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 50, height: 50)
                                .foregroundColor(.black)
                        } else if (gpsAccuracy > 163) {
                            Image(systemName: "network")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 50, height: 50)
                                .foregroundColor(.red)
                        } else if (gpsAccuracy > 48) {
                            Image(systemName: "network")
                                .resizable()
                                .foregroundColor(.yellow)
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 50, height: 50)
                        } else {
                            Image(systemName: "network")
                                .resizable()
                                .foregroundColor(.green)
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 50, height: 50)
                        }
                    }
                }
                .padding()
            }
            
            Spacer()
            
            VStack {
                HStack {
                    Text(String(format: "%.0f", speedInUnits))
                        .font(.custom("VCR OSD Mono", size: 100))
                    Text("\(settings.unitsTitle)")
                        .font(.custom("VCR OSD Mono", size: 30))
                        .padding(.top, 70)
                }
                HStack {
                    Text(String(format: "%.1f", timer.counter))
                        .font(.custom("VCR OSD Mono", size: 100))
                    Text("sec")
                        .font(.custom("VCR OSD Mono", size: 30))
                        .padding(.top, 70)
                }
            }
            .padding()
            
            Spacer()
            
            VStack {
                HStack {
                    Text("\(settings.startRange) - \(settings.finishRange)")
                        .bold()
                    Text((String(format: "%.1f", timer.counter)) + "s")
                        .bold()
                }
                
                if settings.optionalRunIsActive {
                    HStack {
                        Text("\(settings.optionalStartRange) - \(settings.optionalFinishRange)")
                            .bold()
                        Text((String(format: "%.1f", optionalTimer.counter)) + "s")
                            .bold()
                    }
                }
            }
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
            let start = Double(settings.startRange)
            let finish = Double(settings.finishRange)
            
            switch newValue {
            case start...finish:
                timer.start()
            default:
                timer.pause()

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
    
    private func addRun(title: String) {
        withAnimation {
            let newRun = Run(context: context)
            newRun.timestamp = Date()
            newRun.id = UUID()
            newRun.title = title
            newRun.start = Int16(settings.startRange)
            newRun.finish = Int16(settings.finishRange)
            newRun.time = timer.counter
            newRun.unit = settings.unitsTitle
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
        RunView(settings: SettingsManager())
    }
}
