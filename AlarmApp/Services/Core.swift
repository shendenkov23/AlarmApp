//
//  Core.swift
//  AlarmApp
//
//  Created by iDeveloper on 15.02.2020.
//  Copyright © 2020 iDeveloper. All rights reserved.
//

import Foundation

class Core {

  let audioService = AudioService()
  
  // MARK: - Singleton
  
  static let shared = Core()
  private init() { }
  
  // MARK: -
  
  
}
