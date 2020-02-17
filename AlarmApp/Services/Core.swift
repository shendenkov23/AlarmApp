//
//  Core.swift
//  AlarmApp
//
//  Created by shendenkov23 on 15.02.2020.
//  Copyright © 2020 shendenkov23. All rights reserved.
//

import Foundation

class Core {
  let audioService = AudioService()
  let recordingService = RecordingService()
  
  // MARK: - Singleton
  
  static let shared = Core()
  private init() {}
  
  // MARK: -
}
