//
//  String+Extension.swift
//  TextToBinaryFree
//
//  Created by Michael Horowitz on 7/8/21.
//  Copyright © 2021 Stacey Horowitz. All rights reserved.
//

import Foundation

extension String {
///    Returns a string with a removed subrange
    func removedSubrange(_ s: String) -> String {
        var string = self
        if let subrange = self.range(of: s) {
            string.removeSubrange(subrange)
            return string
        }
        return self
    }
}
