//
//  Change Accent Color.swift
//  TextToBinaryFree
//
//  Created by Michael Horowitz on 7/10/21.
//  Copyright © 2021 Stacey Horowitz. All rights reserved.
//

import UIKit

extension UIViewController {
    func updateAccentColor() {
        let notificationAccentColor = "NotificationAccentColor"
        NotificationCenter.default.post(name: Notification.Name(notificationAccentColor), object: nil)
    }

    func createAccentColorObserver(_ selector: Selector) {
        let notificationAccentColor = "NotificationAccentColor"
        NotificationCenter.default.addObserver(self, selector: selector, name: Notification.Name(notificationAccentColor), object: nil)
    }
}
