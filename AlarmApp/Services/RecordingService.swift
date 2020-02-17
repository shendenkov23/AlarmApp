//
//  RecordingService.swift
//  AlarmApp
//
//  Created by iDeveloper on 17.02.2020.
//  Copyright © 2020 iDeveloper. All rights reserved.
//

import AVFoundation
import Foundation

class RecordingService {
  var audioRecorder: AVAudioRecorder!

  init() {
    do {
      try AVAudioSession.sharedInstance().setCategory(.playAndRecord, mode: .default)
      try AVAudioSession.sharedInstance().setActive(true)
      AVAudioSession.sharedInstance().requestRecordPermission { allowed in
        if !allowed {
          // TODO: handle not allowed
        }
      }
    } catch {
      // TODO: handle catch
    }
  }
  
  // MARK: -
  
  private func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
  }
  
  func startRecording() {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy.MM.dd_HH:mm:ss"
    let filenamePrefix = dateFormatter.string(from: Date())
    let audioFilename = getDocumentsDirectory().appendingPathComponent("\(filenamePrefix)-recording.m4a")
    
    let settings = [
      AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
      AVSampleRateKey: 12000,
      AVNumberOfChannelsKey: 1,
      AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
    ]
    
    do {
      audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
      audioRecorder.record()
    } catch {
      finishRecording()
    }
  }
  
  func finishRecording() {
    audioRecorder.stop()
    audioRecorder = nil
  }
}
