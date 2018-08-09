//
//  TimerView.swift
//  BarTimer
//
//  Created by Keaton Burleson on 8/9/18.
//  Copyright © 2018 Keaton Burleson. All rights reserved.
//

import Foundation
import AppKit

class TimerView: NSView {
    @IBOutlet weak var timerField: NSTextField?
    @IBOutlet weak var timeStepper: NSStepper?


    func update(timeLeft: TimeInterval) {
        DispatchQueue.main.async {
            self.timerField?.stringValue = self.stringFromTimeInterval(interval: timeLeft)
        }
    }

    func timerStarted() {
        DispatchQueue.main.async {
            NSAnimationContext.runAnimationGroup({ _ in
                NSAnimationContext.current.duration = 0.5
                self.timerField?.alphaValue = 0.5
                self.timeStepper?.alphaValue = 0.5
                self.timeStepper?.isEnabled = false
            })
        }
    }

    func timerStopped() {
        DispatchQueue.main.async {
            NSAnimationContext.runAnimationGroup({ _ in
                NSAnimationContext.current.duration = 0.5
                self.timerField?.alphaValue = 1.0
                self.timeStepper?.alphaValue = 1.0
                self.timeStepper?.isEnabled = true
            })
        }
    }

    func stringFromTimeInterval(interval: TimeInterval) -> String {
        let interval = Int(interval)
        let seconds = interval % 60
        let minutes = (interval / 60) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

