//
//  MenuController.swift
//  BarTimer
//
//  Created by Keaton Burleson on 8/9/18.
//  Copyright © 2018 Keaton Burleson. All rights reserved.
//

import Foundation
import AppKit
import AVFoundation

class MenuController: NSObject {
    @IBOutlet var timerMenu: NSMenu!
    @IBOutlet var startStopItem: NSMenuItem!
    @IBOutlet var timerView: TimerView!
    @IBOutlet var durationStepper: NSStepper!

    var timerViewItem: NSMenuItem?
    var currentTimer: Timer? = nil

    var currentTimeInterval: TimeInterval = 0

    var timerItem: NSStatusItem? = nil

    override func awakeFromNib() {
        timerViewItem = timerMenu.item(withTitle: "Timer")
        timerViewItem?.view = timerView!
        timerItem = (NSApplication.shared.delegate as! AppDelegate).timerItem
        timerView.update(timeLeft: 900)

        currentTimeInterval = durationStepper.doubleValue
    }

    @IBAction func toggleTimer(sender: NSMenuItem) {
        if (currentTimer == nil) {

            startTimerWithDuration(duration: currentTimeInterval)
            sender.title = "Stop"
            timerView.timerStarted()
        } else {
            timerCancelled()
        }
    }

    func startTimerWithDuration(duration: TimeInterval) {
        if (currentTimer == nil) {
            DispatchQueue.main.async {
                self.currentTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.update(timer:)), userInfo: nil, repeats: true)
                RunLoop.current.add(self.currentTimer!, forMode: RunLoopMode.commonModes)
            }
        }

        startStopItem?.title = "Stop"
    }

    @objc func update(timer: Timer) {
        if (currentTimer != nil) {
            if (currentTimeInterval == 0) {
                timer.invalidate()
                timerStopped()
            } else {
                currentTimeInterval = currentTimeInterval - 1
                timerView.update(timeLeft: currentTimeInterval)
                
                NSAnimationContext.beginGrouping()
                NSAnimationContext.current.duration = 0.5
                timerItem?.image = nil
                timerItem?.title = (timerView.timerField?.stringValue)!
                NSAnimationContext.endGrouping()
            }
        }
    }

    @IBAction func updateField(sender: NSStepper) {
        currentTimeInterval = durationStepper.doubleValue
        timerView.update(timeLeft: sender.doubleValue)
    }

    func timerStopped() {
        let notification = NSUserNotification()
        notification.title = "Timer Finished"
        notification.soundName = nil
        NSUserNotificationCenter.default.deliver(notification)
        NSSound(named: NSSound.Name(rawValue: "alert.m4a"))?.play()
        
        timerCancelled()
    }

    func timerCancelled() {
        timerView.timerStopped()
        timerView.update(timeLeft: 900)

        currentTimer = nil
        startStopItem.title = "Start"
        
        (NSApplication.shared.delegate as! AppDelegate).resetStatusIcon()
    }

    func stringFromTimeInterval(interval: TimeInterval) -> String {
        let interval = Int(interval)
        let seconds = interval % 60
        let minutes = (interval / 60) % 60
        let hours = (interval / 3600)
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}

extension MenuController: NSMenuDelegate {

}
