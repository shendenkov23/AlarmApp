//
//  UIView.swift
//  AlarmApp
//
//  Created by iDeveloper on 13.02.2020.
//  Copyright © 2020 iDeveloper. All rights reserved.
//

import UIKit

extension UIView {
  
  @IBInspectable var cornerRadius: CGFloat {
    get {
      return layer.cornerRadius
    }
    set {
      clipsToBounds = true
      layer.cornerRadius = abs(CGFloat(Int(newValue * 100)) / 100)
    }
  }
}
