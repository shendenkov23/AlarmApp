//
//  ViewController.swift
//  AlarmApp
//
//  Created by shendenkov23 on 13.02.2020.
//  Copyright © 2020 shendenkov23. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  // MARK: - IBOutlets
  
  @IBOutlet private weak var lblSleepTimer: UILabel!
  @IBOutlet private weak var lblAlarmTime: UILabel!
  
  // MARK: -
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
  }

  private func selectTimer(min: Int) {
    lblSleepTimer.text = "\(min) min"
  }
  
  // MARK: - Actions

  @IBAction private func btnTimerPressed(_ sender: UIButton) {
    let timers = [1, 5, 10, 15, 20]
    
    let sheet = UIAlertController(title: "Sleep timer", message: nil, preferredStyle: .actionSheet)
    sheet.addAction(UIAlertAction(title: "off", style: .default, handler: { _ in
      
    }))
    timers.forEach { min in
      sheet.addAction(UIAlertAction(title: "\(min) min", style: .default, handler: { [weak self] _ in
        self?.selectTimer(min: min)
      }))
    }
    sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    present(sheet, animated: true, completion: nil)
  }
  
  @IBAction private func btnAlarmTimePressed(_ sender: UIButton) {
    let picker = UIDatePicker()

    let dummy = UITextField(frame: .zero)
    view.addSubview(dummy)

    dummy.inputView = picker
    
    guard let accessory = UINib(nibName: "InputAccessory", bundle: nil).instantiate(withOwner: nil, options: nil).first as? InputAccessory else { return }
    
    accessory.doneAction = {
      dummy.resignFirstResponder()
    }
    
    accessory.cancelAction = {
      dummy.resignFirstResponder()
    }
    
    dummy.inputAccessoryView = accessory
    dummy.becomeFirstResponder()
  }
  

}

