//
//  CustomIcon.swift
//  TextToBinaryFree
//
//  Created by Stacey Horowitz on 8/24/20.
//  Copyright © 2020 Stacey Horowitz. All rights reserved.
//

import UIKit

class CustomIcon: UITableViewController {
    
    let icons = ["default", "black", "blue", "green", "light purple", "orange", "pink", "purple", "red", "sky blue", "turquoise", "yellow"]
    var iconName = UIApplication.shared.alternateIconName == nil ? "default" : UIApplication.shared.alternateIconName!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "App Icon"
        tableView.register(CustomIconCell.self, forCellReuseIdentifier: "cell")
        setColors()
        createAccentColorObserver(#selector(setColors))
        
    }
    @objc func setColors() {
        navigationController?.navigationBar.tintColor = accentColor
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return icons.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomIconCell
        let image = UIImage(named: icons[indexPath.section])!
        cell.imageView?.image = image
        cell.imageView?.layoutIfNeeded()
        cell.imageView?.layer.cornerRadius = 18
        cell.imageView?.layer.masksToBounds = true
        
        cell.textLabel?.text = icons[indexPath.section].capitalized
        
        if icons[indexPath.section] == iconName {
            cell.accessoryType = .checkmark
        }
        else {
            cell.accessoryType = .none
        }
        cell.tintColor = accentColor

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // check all cells and mark a checkmark at the selected one and remove all other checkmarks
        for section in 0..<tableView.numberOfSections {
            if let cell = tableView.cellForRow(at: IndexPath(row: indexPath.row, section: section)) {
                cell.accessoryType = section == indexPath.section ? .checkmark : .none
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
        if icons[indexPath.section] == "default" {
            UIApplication.shared.setAlternateIconName(nil)
        }
        else {
            UIApplication.shared.setAlternateIconName(icons[indexPath.section])
        }
        
        iconName = icons[indexPath.section]
    }
}
