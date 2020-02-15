//
//  Constants.swift
//  AlarmApp
//
//  Created by iDeveloper on 15.02.2020.
//  Copyright © 2020 iDeveloper. All rights reserved.
//

import UIKit

typealias SimpleAction = () -> ()

enum Color {
  case play
  
  var hex: String {
    switch self {
    case .play: return "#135E1B"
    }
  }
  
  var uiColor: UIColor {
    return UIColor(hex: hex)
  }
}

enum DateFormat: String {
  case alarmTime = "HH:mm"
}
