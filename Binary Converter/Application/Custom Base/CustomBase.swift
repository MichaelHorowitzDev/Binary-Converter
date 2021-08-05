//
//  CustomBase.swift
//  TextToBinaryFree
//
//  Created by Stacey Horowitz on 8/24/20.
//  Copyright © 2020 Stacey Horowitz. All rights reserved.
//

import UIKit
import SCLAlertView
import TableViewDragger
class CustomBase: UITableViewController, UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        print(gestureRecognizer)
        print(gestureRecognizer.state.rawValue)
        if #available(iOS 13.0, *) {
            print(gestureRecognizer.name == "_UISheetInteractionBackgroundDismissRecognizer")
            if gestureRecognizer.name == "_UISheetInteractionBackgroundDismissRecognizer" {
                return false
            }
        }
        return true
    }
    
    @objc func setColors() {
        navigationController?.navigationBar.tintColor = accentColor
    }

    var baseArray = ["Custom Base"]
    var customBase = false
    var customBaseSwitch = UISwitch()
    
    var dragger: TableViewDragger!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Custom Base"
        self.navigationController?.presentationController?.presentedView?.gestureRecognizers?[0].delegate = self
        self.tableView = UITableView(frame: .zero, style: .insetGrouped)
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        setColors()
        createAccentColorObserver(#selector(setColors))
        
        dragger = TableViewDragger(tableView: tableView)
        dragger.availableHorizontalScroll = true
        dragger.dataSource = self
        dragger.delegate = self
        dragger.alphaForCell = 0.7
        customBaseSwitch.onTintColor = accentColor
        customBaseSwitch.addTarget(self, action: #selector(switchPressed(_:)), for: .valueChanged)
        customBase = isCustomBase
        if (customBaseArray != nil) && customBaseArray != [] {
            baseArray = customBaseArray!
        } else {
            setCustomBaseArray(baseArray)
        }
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed(_:)))
         self.navigationItem.rightBarButtonItem = addButton
    }
    
    @objc func switchPressed(_ sender: UISwitch) {
        customBase = customBaseSwitch.isOn
        setIsCustomBase(customBase)
        updateCustomBase()
    }
    @objc func addButtonPressed(_ sender: UIBarButtonItem) {
        showCustomBaseAlert { base in
            if let base = base {
                if self.baseArray.contains("Base-\(base)") == false {
                    self.baseArray.append("Base-\(base)")
                    setCustomBaseArray(self.baseArray)
                    self.tableView.insertRows(at: [IndexPath(row: self.baseArray.count-1, section: 1)], with: .automatic)
                    self.updateCustomBase()
                } else {
                    let alert = UIAlertController(title: "Error", message: "You have already added this base.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return nil
    }
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if section == 1 {
            return "Hold to reorganize. Tap to delete"
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 && baseArray[indexPath.row] != "Custom Base" {
            let alert = UIAlertController(title: "Delete \(baseArray[indexPath.row])", message: "Would you like to delete?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
                self.baseArray.remove(at: indexPath.row)
                setCustomBaseArray(self.baseArray)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                self.updateCustomBase()
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return baseArray.count
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        if indexPath.section == 0 {
            cell.textLabel?.text = "Custom Base"
            customBaseSwitch.setOn(customBase, animated: false)
            cell.accessoryView = customBaseSwitch
            cell.selectionStyle = .none
        } else if indexPath.section == 1 {
            cell.textLabel?.text = baseArray[indexPath.row]
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            baseArray.remove(at: indexPath.row)
            setCustomBaseArray(baseArray)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }

}

extension CustomBase: TableViewDraggerDataSource, TableViewDraggerDelegate {
    func dragger(_ dragger: TableViewDragger, shouldDragAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 0 {
            return false
        }
        else if indexPath.section == 1 {
            return true
        }
        return false
    }
    func dragger(_ dragger: TableViewDragger, moveDraggingAt indexPath: IndexPath, newIndexPath: IndexPath) -> Bool {
        if newIndexPath.section != 1 {
            return false
        }
        let item = baseArray[indexPath.row]
        baseArray.remove(at: indexPath.row)
        baseArray.insert(item, at: newIndexPath.row)
        setCustomBaseArray(baseArray)
        tableView.moveRow(at: indexPath, to: newIndexPath)
        updateCustomBase()

        return true
    }
}
