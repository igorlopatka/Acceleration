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
        VStack {
            HStack {
                Button(action: {
                    vm.resetTimers()
                }) {
                    Image(systemName: "arrow.counterclockwise")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                        .foregroundColor(.primary)
                        .padding()
                }
                
                Spacer()
                
                UnitSwitchView(unit: $vm.unit, isActive: vm.runActive)
                    .onChange(of: vm.unit) { _ in
                        vm.updateUnits()
                    }
                
                Spacer()
                
                Image(systemName: vm.updateSignalSymbol())
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
                    .foregroundColor(vm.updateSignalColor())
                    .padding()
            }
            
            Spacer()
            
            VStack {
                HStack {
                    Text(String(format: "%.0f", vm.speedInUnits))
                        .font(.custom("VCR OSD Mono", size: 100))
                    Text("\(vm.title)")
                        .font(.custom("VCR OSD Mono", size: 30))
                        .padding(.top, 70)
                }
                
                BigTimerLabelView(timer: vm.timer, optionalTimer: vm.optionalTimer)
            }
            .padding()
            
            Spacer()
            
            RunRowListView(vm: vm, timer: vm.timer, optTimer: vm.optionalTimer)
                .frame(alignment: .trailing)
            
            Spacer()
            VStack {
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
                .disabled(vm.runActive)
                .disabled(!vm.runFinished)
            }
            Spacer()
            
            BannerView()
                .frame(height: 120)
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
    }
}
