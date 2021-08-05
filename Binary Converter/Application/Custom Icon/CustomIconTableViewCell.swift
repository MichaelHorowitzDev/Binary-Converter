//
//  CustomIconTableViewCell.swift
//  TextToBinaryFree
//
//  Created by Michael Horowitz on 7/9/21.
//  Copyright © 2021 Stacey Horowitz. All rights reserved.
//

import UIKit

class CustomIconCell: UITableViewCell {
    override func layoutSubviews() {
        super.layoutSubviews()
        self.imageView?.frame = CGRect(x: (self.frame.width-self.frame.width*0.9)/2, y: (self.frame.height-self.frame.height*0.8)/2, width: self.frame.height*0.8, height: self.frame.height*0.8)
        self.imageView?.layer.shadowColor = UIColor.black.cgColor
        self.imageView?.layer.shadowOpacity = 1
        self.imageView?.layer.shadowOffset = CGSize.zero
        self.imageView?.layer.shadowRadius = 10
        self.imageView?.layer.shadowPath = UIBezierPath(roundedRect: self.imageView!.bounds, cornerRadius: 10).cgPath
    }
}
