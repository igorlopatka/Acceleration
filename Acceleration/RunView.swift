//
//  RunView.swift
//  Acceleration
//
//  Created by Igor Łopatka on 14/03/2022.
//

import SwiftUI

struct RunView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Run.timestamp, ascending: true)],
        animation: .default)
    private var runs: FetchedResults<Run>
    

    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    
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
                    Text("100")
                        .font(.custom("VCR OSD Mono", size: 140))
                    Text("km/h")
                        .font(.custom("VCR OSD Mono", size: 30))
                        .padding(.top, 70)
                }
                HStack {
                    Text("04.69")
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
    }
    
    private func addItem() {
        withAnimation {
            let newItem = Run(context: viewContext)
            newItem.timestamp = Date()
            newItem.id = UUID()
            do {
                try viewContext.save()
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
