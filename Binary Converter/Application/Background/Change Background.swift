//
//  Change Background.swift
//  TextToBinaryFree
//
//  Created by Michael Horowitz on 7/11/21.
//  Copyright © 2021 Stacey Horowitz. All rights reserved.
//

import UIKit

extension BackgroundController {
    func updateBackground() {
        let notificationAccentColor = "NotificationBackground"
        NotificationCenter.default.post(name: Notification.Name(notificationAccentColor), object: nil)
    }
}
extension ViewController {
    func createBackgroundObserver(_ selector: Selector) {
        let notificationAccentColor = "NotificationBackground"
        NotificationCenter.default.addObserver(self, selector: selector, name: Notification.Name(notificationAccentColor), object: nil)
    }
}
