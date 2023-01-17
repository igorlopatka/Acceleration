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
    
    @StateObject var vm = RunViewModel()
    @State private var showAlert = false
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    vm.timer.reset()
                    vm.optionalTimer.reset()
                }) {
                    Image(systemName: "arrow.counterclockwise")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                        .foregroundColor(.primary)
                        .padding()
                }
                
                Spacer()
                
                UnitSwitchView(vm: vm)
                    .onChange(of: vm.unit.unit) { _ in
                        vm.unit.updateUnits()
                    }
                
                Spacer()
                
                Image("signal")
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
                    Text("\(vm.unit.title)")
                        .font(.custom("VCR OSD Mono", size: 30))
                        .padding(.top, 70)
                }
                
                BigTimerLabelView(timer: vm.timer, optionalTimer: vm.optionalTimer)
            }
            .padding()
            
            Spacer()
            
            RunRowListView(range: vm.range, timer: vm.timer, optTimer: vm.optionalTimer)
            
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
            vm.requestPermission()
        }
        .onChange(of: vm.speedInUnits, perform: { newValue in
            let start = Double(vm.range.start)
            let finish = Double(vm.range.finish)
            
            switch newValue {
            case start...finish:
                vm.timer.start()
            default:
                vm.timer.pause()
            }
            
            if vm.range.optRunActive {
                let optStart = Double(vm.range.optStart)
                let optFinish = Double(vm.range.optFinish)
                
                switch newValue {
                case optStart...optFinish:
                    vm.optionalTimer.start()
                default:
                    vm.optionalTimer.pause()
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
    
    private func addRun(title: String) {
        withAnimation {
            let newRun = Run(context: context)
            newRun.timestamp = Date()
            newRun.id = UUID()
            newRun.title = title
            newRun.start = Int16(vm.range.start)
            newRun.finish = Int16(vm.range.finish)
            newRun.time = vm.timer.counter
            newRun.unit = vm.unit.title
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
