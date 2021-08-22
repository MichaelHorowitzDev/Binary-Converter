//
//  PerformCalculation.swift
//  TextToBinaryFree
//
//  Created by Michael Horowitz on 7/8/21.
//  Copyright © 2021 Stacey Horowitz. All rights reserved.
//

import Foundation
import BigNumber
func stringTypeToInt(type: String) -> Int? {
    switch type {
    case "Text":
        return 0
    case "Binary":
        return 2
    case "Integer":
        return 10
    case "Hexadecimal":
        return 16
    default:
        if let base = Int(type.removedSubrange("Base-")) {
            if base > 36 || base < 2 {
                return nil
            }
            return base
        }
        return 0
    }
}

func converter(input: String, inputType: String, resultType: String) -> String {
    guard let inputTypeInt = stringTypeToInt(type: inputType) else { return "" }
    guard let resultTypeInt = stringTypeToInt(type: resultType) else { return "" }
    if inputTypeInt == resultTypeInt {
        return input
    }
    if inputTypeInt == 0 {
        let numberString = stringToNumber(string: input)
        let numberArray = numberString.split(separator: " ")
        var baseArray = [String]()
        for num in numberArray {
            let newBase = changeBase(num: String(num), currentBase: 10, newBase: resultTypeInt)
            if newBase == nil {
                return ""
            } else {
                baseArray.append(newBase!)
            }
        }
        return baseArray.joined(separator: " ")
    } else if resultTypeInt == 0 {
        var binaryArray = [String]()
        let numberArray = input.split(separator: " ")
        for num in numberArray {
            let binary = changeBase(num: String(num), currentBase: inputTypeInt, newBase: 2)
            if binary == nil {
                return ""
            } else {
                binaryArray.append(binary!)
            }
        }
        let binary = binaryArray.joined(separator: " ")
        let string = binaryToString(binary: binary)
        return string
    } else {
        let currentBase = input.split(separator: " ").map { String($0) }
        print("current base", currentBase)
        var newBase = [String]()
        for base in currentBase {
            let result = changeBase(num: base, currentBase: inputTypeInt, newBase: resultTypeInt)
            if result == nil {
                return ""
            } else {
                newBase.append(result!)
            }
        }
        print(newBase)
        return newBase.joined(separator: " ")
    }
}

func changeBase(num: String, currentBase: Int, newBase: Int) -> String? {
    print(num, currentBase, newBase)
    guard let base10Number = BInt(num, radix: currentBase) else { return nil }
    let newNum = base10Number.asString(radix: newBase)
    return newNum
}

func stringToNumber(string: String) -> String {
    var str = ""
    var decimalArray: [String] = []
    for item in string {
        if let data = String(item).data(using: String.Encoding.utf8) {
            for byte in data {
                let binaryNumber = String.init(byte, radix: 2)
                decimalArray.append("\(BInt(binaryNumber, radix: 2)!)")
            }
        }
    }
    str = decimalArray.joined(separator: " ")
    return str
}

func binaryToString(binary: String) -> String {
    var str = ""
    let binaryArray: [String] = binary.split(separator: " ").map {String($0)}
    var numberArray: [Int] = []
    print(binaryArray)
    for byte in binaryArray {
        if byte.count > 8 {
            break
        }
        if let intToAdd = Int.init(byte, radix: 2){
            if intToAdd < 0 {
                break
            }
            numberArray.append(intToAdd)
        }
        else {
            break
        }
    }
    let uint8Array = numberArray.map {UInt8($0)}
    let stringData = Data(bytes: uint8Array, count: uint8Array.count)
    if let dataAsString = String(data: stringData, encoding: .utf8){
        str = dataAsString
    }
    return str
}

//custom base
func customToBinary(custom: String, base: Int) -> String {
    let customArray: [String] = custom.split(separator: " ").map {String($0)}
    var binaryArray: [String] = []
    var str = ""
    for hex in customArray {
        if let binary = BInt(hex, radix: base) {
            binaryArray.append(String(binary, radix: 2))
        }
        else {
            str = binaryArray.joined(separator: " ")
            return str
        }
    }
    str = binaryArray.joined(separator: " ")
    return str
}

func binToCustom(_ bin: String, base: Int) -> String? {
    // binary to integer:
    guard let num = BInt(bin, radix: 2) else { return nil }
    // integer to hex:
    let custom = String(num, radix: base) // (or false)
    return custom
}

func binaryToCustom(custom: String, base: Int) -> String {
    let binaryArray: [String] = custom.split(separator: " ").map {String($0)}
    var customArray: [String] = []
    var str = ""
    for bin in binaryArray {
        if let hex = binToCustom(bin, base: base){
            customArray.append(hex)
        }
        else{
            str = customArray.joined(separator: " ")
            return str
        }
    }
    str = customArray.joined(separator: " ")
    return str
}
