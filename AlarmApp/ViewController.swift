//
//  ViewController.swift
//  AlarmApp
//
//  Created by shendenkov23 on 13.02.2020.
//  Copyright © 2020 shendenkov23. All rights reserved.
//

import AVFoundation
import UIKit

enum SleepAppState {
  case `default`
  case playing
  case recording
  case alarm
  
  var description: String {
    switch self {
    case .default: return "Press play"
    case .playing: return "Playing"
    case .recording: return "Recording"
    case .alarm: return "Wake up!"
    }
  }
}

class ViewController: UIViewController {
  var currentState: SleepAppState = .default
  
  // MARK: - IBOutlets
  
  @IBOutlet private weak var lblDescription: UILabel!
  @IBOutlet private weak var lblSleepTimer: UILabel!
  @IBOutlet private weak var lblAlarmTime: UILabel!
  @IBOutlet private weak var btnPlay: UIButton!
  
  // MARK: -
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
  }
  
  // MARK: -
  
  private func selectTimer(min: Int) {
    lblSleepTimer.text = "\(min) min"
  }
  
  private func makeAlarmTimeInputAccessory(doneAction: @escaping SimpleAction,
                                           cancelAction: @escaping SimpleAction) -> InputAccessory? {
    guard let accessory: InputAccessory = .instantiate() else { return nil }
    accessory.doneAction = doneAction
    accessory.cancelAction = cancelAction
    
    return accessory
  }
  
  private func makeSleepTimerActionSheet() -> UIAlertController {
    let sheet = UIAlertController(title: "Sleep timer", message: nil, preferredStyle: .actionSheet)
    sheet.addAction(UIAlertAction(title: "off", style: .default, handler: { _ in
      //TODO: off action
    }))
    let timers = [1, 5, 10, 15, 20]
    timers.forEach { min in
      sheet.addAction(UIAlertAction(title: "\(min) min", style: .default, handler: { [weak self] _ in
        self?.selectTimer(min: min)
      }))
    }
    sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    return sheet
  }
  
  // MARK: - Actions
  
  @IBAction private func btnTimerPressed(_ sender: UIButton) {
    let sheet = makeSleepTimerActionSheet()
    present(sheet, animated: true, completion: nil)
  }
  
  @IBAction private func btnAlarmTimePressed(_ sender: UIButton) {
    let dummy = UITextField(frame: .zero)
    view.addSubview(dummy)
    
    let picker = UIDatePicker()
    picker.datePickerMode = .time
    dummy.inputView = picker
    
    guard let accessory = makeAlarmTimeInputAccessory(doneAction: { [weak self] in
      let formatter = DateFormatter(dateFormat: DateFormat.alarmTime.rawValue)
      self?.lblAlarmTime.text = formatter.string(from: picker.date)
      
      dummy.resignFirstResponder()
      dummy.removeFromSuperview()
    }, cancelAction: {
      dummy.resignFirstResponder()
      dummy.removeFromSuperview()
    }) else { return }
    
    dummy.inputAccessoryView = accessory
    dummy.becomeFirstResponder()
  }
  
  @IBAction private func btnPlayPressed(_ sender: UIButton) {
    switch currentState {
    case .default:
      Core.shared.audioService.playNature()
      currentState = .playing
      btnPlay.setTitle("Pause", for: .normal)
    case .playing:
      Core.shared.audioService.stop()
      currentState = .default
      btnPlay.setTitle("Play", for: .normal)
    case .recording:
      break
    case .alarm:
      break
    }
    lblDescription.text = currentState.description
  }
}
