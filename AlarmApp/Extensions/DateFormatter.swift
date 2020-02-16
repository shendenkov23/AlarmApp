//
//  DateFormatter.swift
//  AlarmApp
//
//  Created by shendenkov23 on 15.02.2020.
//  Copyright © 2020 shendenkov23. All rights reserved.
//

import Foundation

extension DateFormatter {
  convenience init(dateFormat: String) {
    self.init()
    self.dateFormat = dateFormat
  }
}
