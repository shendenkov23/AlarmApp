//
//  AudioService.swift
//  AlarmApp
//
//  Created by shendenkov23 on 15.02.2020.
//  Copyright © 2020 shendenkov23. All rights reserved.
//

import AVFoundation
import Foundation

enum SoundType {
  case nature
  case alarm
  
  var fileurl: URL? {
    var filename = ""
    switch self {
    case .nature: filename = "nature"
    case .alarm: filename = "alarm"
    }
    return Bundle.main.url(forResource: filename, withExtension: "m4a")
  }
  
  var numberOfLoops: Int {
    switch self {
    case .nature: return -1
    case .alarm: return 0
    }
  }
}

protocol AudioServiceDelegate: class {
  func didPlayToEnd(soundType: SoundType)
}

class AudioService: NSObject {
  weak var delegate: AudioServiceDelegate?
  var player: AVAudioPlayer?
  
  private var currentSound: SoundType?
  
  // MARK: -
  
  func play(_ sound: SoundType) {
    guard let url = sound.fileurl else { return }
    stop()
    
    do {
      let player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
      player.delegate = self
      self.player = player
      player.numberOfLoops = sound.numberOfLoops
      player.prepareToPlay()
      
      currentSound = sound
      player.play()
    } catch {
      print("AVPlayer Exception:", error.localizedDescription)
    }
  }
  
  func stop() {
    player?.stop()
    player = nil
  }
}

// MARK: - AVAudioPlayerDelegate

extension AudioService: AVAudioPlayerDelegate {
  func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
    stop()
    
    guard let currentSound = currentSound else { return }
    delegate?.didPlayToEnd(soundType: currentSound)
    self.currentSound = nil
  }
}
