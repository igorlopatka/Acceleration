//
//  SoundManager.swift
//  Acceleration
//
//  Created by Igor Łopatka on 14/10/2022.
//

import Foundation
import AVKit

class SoundManager: ObservableObject {
    
    @Published var player: AVAudioPlayer!
    
    let finishSound = Bundle.main.path(forResource: "finish", ofType: "mp3")
    
    func playFinishSound() {
        self.player = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: finishSound!))
    }
}
