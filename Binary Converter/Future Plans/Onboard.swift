//
//  Onboard.swift
//  TextToBinaryFree
//
//  Created by Stacey Horowitz on 3/8/21.
//  Copyright © 2021 Stacey Horowitz. All rights reserved.
//

import UIKit
import paper_onboarding
class Onboard: UIViewController, PaperOnboardingDelegate, PaperOnboardingDataSource {
    
    func onboardingItem(at index: Int) -> OnboardingItemInfo {

       return [
         OnboardingItemInfo(informationImage: #imageLiteral(resourceName: "1024"),
                                       title: "Binary Converter",
                                 description: "How this app works",
                                    pageIcon: #imageLiteral(resourceName: "1024"),
                                       color: UIColor.defaultBackground,
                                  titleColor: UIColor.label,
                            descriptionColor: UIColor.label,
                                   titleFont: UIFont.systemFont(ofSize: 20),
                             descriptionFont: UIFont.systemFont(ofSize: 20)),
         ][index]
     }

     func onboardingItemsCount() -> Int {
        return 1
      }
    
    @objc func skipButtonPressed() {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        let skipButton = UIButton()
        skipButton.setTitle("Skip", for: .normal)
        skipButton.backgroundColor = .clear
        skipButton.addTarget(self, action: #selector(skipButtonPressed), for: .touchUpInside)
        view.addSubview(skipButton)
        skipButton.translatesAutoresizingMaskIntoConstraints = false
        skipButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        skipButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 40).isActive = true
        view.addSubview(skipButton)
        let onboarding = PaperOnboarding()
        onboarding.dataSource = self
        onboarding.translatesAutoresizingMaskIntoConstraints = false
          view.addSubview(onboarding)
        view.bringSubviewToFront(skipButton)

          // add constraints
        for attribute: NSLayoutConstraint.Attribute in [.left, .right, .top, .bottom] {
            let constraint = NSLayoutConstraint(item: onboarding,
                                                attribute: attribute,
                                                relatedBy: .equal,
                                                toItem: view,
                                                attribute: attribute,
                                                multiplier: 1,
                                                constant: 0)
            view.addConstraint(constraint)
          }
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
