//
//  Int+Extensions.swift
//  Int+Extensions
//
//  Created by Michael Horowitz on 8/22/21.
//  Copyright © 2021 Stacey Horowitz. All rights reserved.
//

import Foundation

extension Int {
    func setMinimumNumber(_ number: Int) -> Int {
        self > number ? self : number
    }
}
