//
//  AppDelegate.swift
//  BarTimer
//
//  Created by Keaton Burleson on 8/9/18.
//  Copyright © 2018 Keaton Burleson. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    @IBOutlet var timerMenu: NSMenu!

    let timerItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    let icon = NSImage(named: NSImage.Name(rawValue: "clock_icon"))

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        icon?.isTemplate = true // best for dark mode
        timerItem.image = icon
        timerItem.menu = timerMenu
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    public func resetStatusIcon() {
        timerItem.title = nil
        timerItem.image = icon
    }

    @IBAction func quitButtonClicked(_ sender: Any) {
        NSApplication.shared.terminate(self)
    }

}

