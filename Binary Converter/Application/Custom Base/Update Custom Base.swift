//
//  Update Custom Base.swift
//  TextToBinaryFree
//
//  Created by Michael Horowitz on 7/12/21.
//  Copyright © 2021 Stacey Horowitz. All rights reserved.
//

import UIKit

extension ViewController {
    func createCustomBaseObserver(_ selector: Selector) {
        NotificationCenter.default.addObserver(self, selector: selector, name: Notification.Name("NotificationCustomBase"), object: nil)
    }
}

extension CustomBase {
    func updateCustomBase() {
        NotificationCenter.default.post(name: Notification.Name("NotificationCustomBase"), object: nil)
    }
}

var isCustomBase: Bool {
    UserDefaults.standard.bool(forKey: "isCustomBase")
}

func setIsCustomBase(_ bool: Bool) {
    UserDefaults.standard.set(bool, forKey: "isCustomBase")
}

var customBaseArray: [String]? {
    UserDefaults.standard.stringArray(forKey: "customBase")
}

func setCustomBaseArray(_ array: [String]) {
    UserDefaults.standard.set(array, forKey: "customBase")
}
