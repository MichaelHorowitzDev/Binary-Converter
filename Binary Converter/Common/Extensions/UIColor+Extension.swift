//
//  UIColor+Extension.swift
//  TextToBinaryFree
//
//  Created by Michael Horowitz on 7/10/21.
//  Copyright © 2021 Stacey Horowitz. All rights reserved.
//

import UIKit

extension UIColor {
    // solid image from color
    func image(_ size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { rendererContext in
            self.setFill()
            rendererContext.fill(CGRect(origin: .zero, size: size))
        }
    }
    //convert hex to uicolor
    convenience init(rgbHexaValue: Int, alpha: CGFloat = 1.0) {
        self.init(red:  CGFloat((rgbHexaValue >> 16) & 0xFF), green: CGFloat((rgbHexaValue >> 8) & 0xFF), blue: CGFloat(rgbHexaValue & 0xFF), alpha: alpha)
      }
    // color as uint
    var asUInt: UInt {
        let red: CGFloat = rgba.red
        let green: CGFloat = rgba.green
        let blue: CGFloat = rgba.blue
        print(red, green, blue)
        var colorAsUInt : UInt = 0

            colorAsUInt += UInt(red * 255.0) << 16 +
                           UInt(green * 255.0) << 8 +
                           UInt(blue * 255.0)
        print("color as uint", colorAsUInt)
        print(colorAsUInt == 0xFF0000)
        return colorAsUInt
    }
    // get rgba values from color
    var rgba: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        var alpha: CGFloat = 0.0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        return (red: red, green: green, blue: blue, alpha: alpha)
    }
    // whether color is light or dark
    var isLight: Bool {
        let red = self.cgColor.components![0]*255
        let green = self.cgColor.components![1]*255
        let blue = self.cgColor.components![2]*255
        if ((red*299)+(green*587)+(blue*114))/1000 < 150 {
            return true
        }
        return false
    }
    class var defaultBackground: UIColor {
        return UIColor(named: "Background")!
    }
    // create color from data
    class func color(withData data: Data) -> UIColor? {
        do {
            return try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? UIColor
        } catch {
            return nil
        }
    }
    // encode color to data
    func encode() -> Data {
        do {
            return try NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: false)
        } catch {
            return Data()
        }
    }
}
