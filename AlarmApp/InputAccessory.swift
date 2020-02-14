//
//  InputAccessory.swift
//  AlarmApp
//
//  Created by iDeveloper on 14.02.2020.
//  Copyright © 2020 iDeveloper. All rights reserved.
//

import UIKit

class InputAccessory: UIView {
  
  var doneAction: (() -> ())?
  var cancelAction: (() -> ())?
  
  // MARK: - Actions
  
  @IBAction private func btnDonePressed(_: UIButton) {
    doneAction?()
  }
  
  @IBAction private func btnCancelPressed(_: UIButton) {
    cancelAction?()
  }
}
