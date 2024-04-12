//
//  UsageManager.swift
//  franklin
//
//  Created by Denis Ronchese on 25/03/24.
//

import DeviceActivity

class AppUsageMonitor: DeviceActivityMonitor {
    override func intervalDidStart(for activity: DeviceActivityName) {
        // Code for what should happen when a monitored interval starts
    }

    override func intervalDidEnd(for activity: DeviceActivityName) {
        // Code for what should happen when a monitored interval ends
    }
    
//    override func eventDidReachThreshold(for event: DeviceActivityEventName, during activity: DeviceActivityName) {
//        // Code for what should happen when a usage threshold is reached
//    }
}
