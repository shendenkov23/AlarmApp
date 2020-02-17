//
//  ViewController.swift
//  AlarmApp
//
//  Created by shendenkov23 on 13.02.2020.
//  Copyright © 2020 shendenkov23. All rights reserved.
//

import AVFoundation
import UIKit
import UserNotifications

let alarmNotificationIdentifier = "com.alarm"

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
    case .alarm: return "Alarm. Wake up!"
    }
  }
}

class ViewController: UIViewController {
  var currentState: SleepAppState = .default {
    didSet {
      lblDescription.text = currentState.description
    }
  }
  
  private var selectedAsleepTime: TimeInterval?
  private var asleepTimer: Timer?
  
  private var selectedAlarmTime: Date? {
    didSet {
      if let selectedAlarmTime = selectedAlarmTime {
        let formatter = DateFormatter(dateFormat: DateFormat.alarmTime.rawValue)
        lblAlarmTime.text = formatter.string(from: selectedAlarmTime)
      } else {
        lblAlarmTime.text = "Select"
      }
    }
  }
  
  // MARK: - IBOutlets
  
  @IBOutlet private weak var lblDescription: UILabel!
  @IBOutlet private weak var lblSleepTimer: UILabel!
  @IBOutlet private weak var lblAlarmTime: UILabel!
  @IBOutlet private weak var btnPlay: UIButton!
  
  // MARK: -
  
  override func viewDidLoad() {
    super.viewDidLoad()
    UNUserNotificationCenter.current().delegate = self
    Core.shared.audioService.delegate = self
  }
  
  // MARK: -
  
  private func selectTimer(min: Int?) {
    if let min = min {
      lblSleepTimer.text = "\(min) min"
      selectedAsleepTime = TimeInterval(min * 60)
    } else {
      lblSleepTimer.text = "off"
      selectedAsleepTime = nil
    }
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
    sheet.addAction(UIAlertAction(title: "off", style: .default, handler: { [weak self] _ in
      self?.selectTimer(min: nil)
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
  
  private func makeAlarmNotification(date: Date) {
    let dateComponents = Calendar.current.dateComponents(.init(arrayLiteral: .hour, .minute), from: date)
    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
    
    let content = UNMutableNotificationContent()
    
    content.title = "Wake Up"
    content.body = "The early bird catches the worm, but the second mouse gets the cheese."
    content.sound = .default
    
    let request = UNNotificationRequest(identifier: alarmNotificationIdentifier, content: content, trigger: trigger)
    
    UNUserNotificationCenter.current().add(request) { _ in }
  }
  
  private func showError(_ error: String) {
    let alert = UIAlertController(title: nil, message: error, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
    present(alert, animated: true, completion: nil)
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
      self?.selectedAlarmTime = picker.date
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
    asleepTimer?.invalidate()
    asleepTimer = nil
    
    switch currentState {
    case .default:
      guard let asleepTime = selectedAsleepTime else {
        showError("Select asleep time")
        return
      }
      
      guard let alarmTime = selectedAlarmTime else {
        showError("Select alarm time")
        return
      }
      
      Core.shared.audioService.play(.nature)
      makeAlarmNotification(date: alarmTime)
      btnPlay.setTitle("Pause", for: .normal)
      
      asleepTimer = Timer.scheduledTimer(withTimeInterval: asleepTime, repeats: false) { [weak self] _ in
        Core.shared.audioService.stop()
        Core.shared.recordingService.startRecording()
        self?.currentState = .recording
        
        self?.asleepTimer?.invalidate()
        self?.asleepTimer = nil
      }
      
      currentState = .playing
    case .recording:
      Core.shared.recordingService.finishRecording()
      fallthrough
    case .playing, .alarm:
      Core.shared.audioService.stop()
      btnPlay.setTitle("Play", for: .normal)
      UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [alarmNotificationIdentifier])
      currentState = .default
    }
  }
}

// MARK: - UNUserNotificationCenterDelegate

extension ViewController: UNUserNotificationCenterDelegate {
  func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    Core.shared.recordingService.finishRecording()
    asleepTimer?.invalidate()
    asleepTimer = nil
    
    Core.shared.audioService.play(.alarm)
    currentState = .alarm
    btnPlay.setTitle("Pause", for: .normal)
    completionHandler([])
  }
}

// MARK: - AudioServiceDelegate

extension ViewController: AudioServiceDelegate {
  func didPlayToEnd(soundType: SoundType) {
    if soundType == .alarm {
      Core.shared.audioService.stop()
      btnPlay.setTitle("Play", for: .normal)
      currentState = .default
    }
  }
}
