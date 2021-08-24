//
//  AppDelegate.swift
//  TextToBinaryFree
//
//  Created by Stacey Horowitz on 3/1/20.
//  Copyright © 2020 Stacey Horowitz. All rights reserved.
//

import UIKit
import Siren
import Armchair
import IQKeyboardManagerSwift
@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.shared.enable = true
        Siren.shared.wail()
        Armchair.appID("1501111820")
        Armchair.appName("Binary Converter Calculator")
        Armchair.daysUntilPrompt(2)
        Armchair.usesUntilPrompt(3)
        Armchair.daysBeforeReminding(2)
        Armchair.shouldPromptIfRated(false)
        if let data = UserDefaults.standard.data(forKey: "accentColor") {
            accentColor = UIColor.color(withData: data)!
        }
        return true
    }
}

