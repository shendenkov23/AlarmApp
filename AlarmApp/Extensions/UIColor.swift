//
//  UIColor.swift
//  AlarmApp
//
//  Created by shendenkov23 on 15.02.2020.
//  Copyright © 2020 shendenkov23. All rights reserved.
//

import UIKit

extension UInt64 {
  var cgFloat: CGFloat {
    return CGFloat(self)
  }
}

extension Int {
  var cgFloat: CGFloat {
    return CGFloat(self)
  }
}

extension UIColor {
  convenience init(hex: String?) {
    guard let hex = hex else {
      self.init(red: 0, green: 0, blue: 0, alpha: 1)
      return
    }
    
    var red: CGFloat = 0
    var green: CGFloat = 0
    var blue: CGFloat = 0
    var alpha: CGFloat = 1
    
    if hex.hasPrefix("#") {
      let start = hex.index(hex.startIndex, offsetBy: 1)
      let hexColor = String(hex[start...])
      
      var hexNumber: UInt64 = 0
      let scanner = Scanner(string: hexColor)
      scanner.scanHexInt64(&hexNumber)
      
      if hexColor.count == 8 {
        red =   ((hexNumber & 0xFF000000) >> 24).cgFloat / 255.0
        green = ((hexNumber & 0x00FF0000) >> 16).cgFloat / 255.0
        blue =  ((hexNumber & 0x0000FF00) >> 8).cgFloat / 255.0
        alpha = (hexNumber & 0x000000FF).cgFloat / 255.0
      } else if hexColor.count == 6 {
        let mask = 0x000000FF
        red = (Int(hexNumber >> 16) & mask).cgFloat / 255.0
        green = (Int(hexNumber >> 8) & mask).cgFloat / 255.0
        blue = (Int(hexNumber) & mask).cgFloat / 255.0
      }
    }
    self.init(red: red, green: green, blue: blue, alpha: alpha)
  }
  
  convenience init(red: Int, green: Int, blue: Int) {
    assert(red >= 0 && red <= 255, "Invalid red component")
    assert(green >= 0 && green <= 255, "Invalid green component")
    assert(blue >= 0 && blue <= 255, "Invalid blue component")
    
    self.init(red: red.cgFloat / 255.0, green: green.cgFloat / 255.0, blue: blue.cgFloat / 255.0, alpha: 1.0)
  }
  
  convenience init(rgb: Int) {
    self.init(
      red: (rgb >> 16) & 0xFF,
      green: (rgb >> 8) & 0xFF,
      blue: rgb & 0xFF
    )
  }
  
  static func random() -> UIColor {
    let red = Int.random(in: 0...255)
    let green = Int.random(in: 0...255)
    let blue = Int.random(in: 0...255)
    
    return UIColor(red: red, green: green, blue: blue)
  }
}
