//
//  UIImage+Extension.swift
//  TextToBinaryFree
//
//  Created by Michael Horowitz on 7/12/21.
//  Copyright © 2021 Stacey Horowitz. All rights reserved.
//

import UIKit

extension UIImage {
    func saveImage(imageName: String) {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        let fileName = imageName
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        guard let data = self.jpegData(compressionQuality: 1) else { return }
        
        //Checks if file exists, removes it if so.
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
                print("Removed old image")
            } catch let removeError {
                print("couldn't remove file at path", removeError)
            }
        }
        
        do {
            try data.write(to: fileURL)
        } catch let error {
            print("error saving file with error", error)
        }
    }
    
    class func deleteImageFromDiskWith(fileName: String) {
        let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)
        if let dirPath = paths.first {
            let imageUrl = URL(fileURLWithPath: dirPath).appendingPathComponent(fileName)
            if FileManager.default.fileExists(atPath: imageUrl.path) {
                do {
                    try FileManager.default.removeItem(atPath: imageUrl.path)
                    print("Removed old image")
                } catch let removeError {
                    print("couldn't remove file at path", removeError)
                }
            }
        }
    }
    
    class func loadImageFromDiskWith(fileName: String) -> UIImage? {
        let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
        
        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)
        
        if let dirPath = paths.first {
            let imageUrl = URL(fileURLWithPath: dirPath).appendingPathComponent(fileName)
            let image = UIImage(contentsOfFile: imageUrl.path)
            return image
        }
        return nil
    }
    
    func resizedImageWith(targetSize: CGSize) -> UIImage {
        let imageSize = self.size
        let newWidth  = targetSize.width  / self.size.width
        let newHeight = targetSize.height / self.size.height
        var newSize: CGSize

        if(newWidth > newHeight) {
            newSize = CGSize(width: imageSize.width * newHeight, height: imageSize.height * newHeight)
        } else {
            newSize = CGSize(width: imageSize.width * newWidth,  height: imageSize.height * newWidth)
        }

        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)

        self.draw(in: rect)

        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        return newImage
    }
}
