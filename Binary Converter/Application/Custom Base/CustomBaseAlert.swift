//
//  CustomBaseAlert.swift
//  TextToBinaryFree
//
//  Created by Michael Horowitz on 7/12/21.
//  Copyright © 2021 Stacey Horowitz. All rights reserved.
//

import SCLAlertView

enum CustomBaseAlert {
    case normal, incorrect
}

func showCustomBaseAlert(_ alertType: CustomBaseAlert = .normal, closure: @escaping (_ base: Int?) -> Void) {
    let alert = SCLAlertView()
    let txt = alert.addTextField()
    txt.keyboardType = .numberPad
    var subtitle = "Enter a number greater than 1 and less than 37"
    if alertType == .incorrect {
        subtitle = "Invalid Base.\nEnter a number greater than 1 and less than 37"
    }
    alert.showTitle(
        "Custom Base",
        subTitle: subtitle,
        timeout: nil,
        completeText: "Done",
        style: .edit,
        colorStyle: accentColor.asUInt,
        colorTextButton: accentColor.isLight ? 0xFFFFFF : 0x000000
    ).setDismissBlock {
        if (txt.text ?? "") != "" {
            if let base = Int(txt.text!) {
                if base >= 2 && base <= 36 {
                    closure(base)
                    return
                }
            }
            showCustomBaseAlert(.incorrect) { base in
                closure(base)
            }
        } else {
            closure(nil)
        }
    }
}
