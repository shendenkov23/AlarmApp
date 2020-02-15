//
//  DateFormatter.swift
//  AlarmApp
//
//  Created by iDeveloper on 15.02.2020.
//  Copyright © 2020 iDeveloper. All rights reserved.
//

import Foundation

extension DateFormatter {
  convenience init(dateFormat: String) {
    self.init()
    self.dateFormat = dateFormat
  }
}
