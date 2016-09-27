//
//  UNUserNotificationCenter.swift
//  Bacground Locations Test
//
//  Created by Cristian Bellomo on 27/09/2016.
//  Copyright © 2016 Grocerest. All rights reserved.
//

import UserNotifications

extension UNUserNotificationCenter {
    
    static func alert(title: String, body: String, identifier: String = "alert") {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            if granted {
                let content = UNMutableNotificationContent()
                content.title = title
                content.body = body
                content.sound = UNNotificationSound.default()
                
                // create a 1-second delay for our alert
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
                
                // the identifier lets you cancel the alert later if needed
                let request = UNNotificationRequest(identifier: "LocationsReceived", content: content, trigger: trigger)
                
                // schedule the alert to run
                center.add(request)
            }
        }
    }
    
}
