//
//  AudioService.swift
//  AlarmApp
//
//  Created by iDeveloper on 15.02.2020.
//  Copyright © 2020 iDeveloper. All rights reserved.
//

import AVFoundation
import Foundation

class AudioService {
  var player: AVAudioPlayer?
  
  func playNature() {
    guard let url = Bundle.main.url(forResource: "nature", withExtension: "m4a") else { return }

    player?.stop()
    
    do {
      let player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
      self.player = player
      player.numberOfLoops = -1
      player.prepareToPlay()
      player.play()

    } catch {
      print("AVPlayer Exception:", error.localizedDescription)
    }
  }
  
  func stop() {
    player?.stop()
  }
}
