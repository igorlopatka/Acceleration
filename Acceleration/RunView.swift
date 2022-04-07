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
    
    @StateObject var locationController = LocationController()
    @StateObject var timerController = TimerController()
    
    
    @State private var showAlert = false
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    timerController.start()
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
                        Text("GPS SIGNAL")
                        Image(systemName: "network")
                            .foregroundColor(.green)
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
                    Text(String(format: "%.0f", locationController.lastSeenLocation?.speed ?? 0))
                        .font(.custom("VCR OSD Mono", size: 100))
                    Text("m/s")
                        .font(.custom("VCR OSD Mono", size: 30))
                        .padding(.top, 70)
                }
                HStack {
                    Text(String(format: "%.2f", timerController.counter))
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
                    Text("0-100")
                        .bold()
                    Text("04.69s")
                        .bold()
                    
                }
                HStack {
                    Text("0-100")
                        .bold()
                    Text("04.69s")
                        .bold()
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
        .alert(isPresented: $showAlert,
               TextAlert(title: "Title",
                         message: "Message",
                         keyboardType: .numberPad) { result in
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
        RunView()
    }
}
