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
    @ObservedObject var settings: Settings
    
    
    @State private var showAlert = false
    
    var speedInUnits: Double {
        let speedMS = locationController.lastSeenLocation?.speed ?? 0
        return (Double(speedMS) * settings.unitsMultiplier)
    }
    
    var gpsAccuracy: Double {
        let accuracy =  locationController.lastSeenLocation?.horizontalAccuracy
        return Double(accuracy ?? 0)
    }
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    timer.timer.invalidate()
                    timer.counter = 0.0
                    timer.mode = .stopped
                }) {
                    Image(systemName: "arrow.counterclockwise")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                        .foregroundColor(.black)
                        .padding()
                }
                Spacer()
                VStack {
                    HStack {
                        
                        // Make it better in the future!
                        
                        Text("GPS SIGNAL")
                        if (gpsAccuracy < 0) {
                            Image(systemName: "network")
                                .foregroundColor(.black)
                        } else if (gpsAccuracy > 163) {
                            Image(systemName: "network")
                                .foregroundColor(.red)
                        } else if (gpsAccuracy > 48) {
                            Image(systemName: "network")
                                .foregroundColor(.yellow)
                        } else {
                            Image(systemName: "network")
                                .foregroundColor(.green)
                        }
                        
                        
                    }
                    HStack {
                        Text("WEATHER")
                        Image(systemName: "cloud.rain.fill")
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
                    Text(String(format: "%.2f", timer.counter))
                        .font(.custom("VCR OSD Mono", size: 100))
                    Text("s")
                        .font(.custom("VCR OSD Mono", size: 30))
                        .padding(.top, 50)
                }
            }
            .padding()
            
            Spacer()
            VStack {
                HStack {
                    Text("\(settings.startRange) - \(settings.finishRange)")
                        .bold()
                    Text("04.69s")
                        .bold()

                }
                
                if settings.optionalRunIsActive {
                    HStack {
                        Text("\(settings.optionalStartRange) - \(settings.optionalFinishRange)")
                            .bold()
                        Text("04.69s")
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
               TextAlert(title: "Title",
                         message: "Message",
                         keyboardType: .default) { result in
            if let text = result {
                // Save Run - CoreData operation
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
        RunView(settings: Settings())
    }
}
