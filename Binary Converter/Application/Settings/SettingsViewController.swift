//
//  TableViewController.swift
//  TextToBinaryFree
//
//  Created by Stacey Horowitz on 3/1/20.
//  Copyright © 2020 Stacey Horowitz. All rights reserved.
//

import UIKit
import MessageUI

class SettingsViewController: UITableViewController, MFMailComposeViewControllerDelegate, UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        print(gestureRecognizer)
        return true
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return items.count
        }
        else if section == 1 {
            return customization.count
        }
        else if section == 2 {
            return tutorial.count
        }
        return 0
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "General"
        }
        else if section == 1 {
            return "Customization"
        }
        return nil
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if indexPath.section == 0 {
            cell.textLabel?.text = items[indexPath.row]
        } else if indexPath.section == 1 {
            cell.textLabel?.text = customization[indexPath.row]
            if ["Custom Base", "App Icon", "Accent Color", "Background"].contains(customization[indexPath.row]) {
                let image = UIImage(systemName: "chevron.right")
                let imageView = UIImageView(image: image)
                imageView.tintColor = accentColor
                cell.accessoryView = imageView
            }
        }
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            switch items[indexPath.row] {
            case "Rate App":
                let appID = "1501111820"
                let urlStr = "https://itunes.apple.com/app/id\(appID)?action=write-review"
                guard let url = URL(string: urlStr), UIApplication.shared.canOpenURL(url) else { return }
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
            case "Share":
                let items: [Any] = ["Check out this app!", URL(string: "https://itunes.apple.com/app/id1501111820")!]
                let activity = UIActivityViewController(activityItems: items, applicationActivities: nil)
                activity.popoverPresentationController?.sourceView = self.view
                activity.popoverPresentationController?.sourceRect = self.view.bounds
                present(activity, animated: true, completion: nil)
            case "Support":
                if MFMailComposeViewController.canSendMail() {
                    let mail = MFMailComposeViewController()
                    mail.mailComposeDelegate = self
                    mail.setToRecipients(["michaelhorowitzdev@gmail.com"])
                    let version = Bundle.main.infoDictionary!["CFBundleShortVersionString"]! as! String
                    mail.setMessageBody("<p><br><br><br><br>Version \(version)</p>", isHTML: true)

                    present(mail, animated: true)
                } else {
                    let alert = UIAlertController(title: "Error", message: "Couldn't show mail", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    present(alert, animated: true, completion: nil)
                }
            default:
                print("error")
            }
        }
        else if indexPath.section == 1 {
            switch customization[indexPath.row] {
            case "App Icon":
                navigationController?.pushViewController(CustomIcon(), animated: true)
            case "Custom Base":
                navigationController?.pushViewController(CustomBase(), animated: true)
            case "Accent Color":
                let layout = UICollectionViewFlowLayout()
                layout.scrollDirection = .vertical
                layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
                layout.itemSize = CGSize(width: 100, height: 100)
                navigationController?.pushViewController(AccentColorController(collectionViewLayout: layout), animated: true)
            case "Background":
                let layout = UICollectionViewFlowLayout()
                layout.scrollDirection = .vertical
                layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
                layout.itemSize = CGSize(width: 100, height: 100)
                navigationController?.pushViewController(BackgroundController(collectionViewLayout: layout), animated: true)
            default:
                print("error")
            }
        }
//        else if indexPath.section == 2 {
//            if tutorial[indexPath.row] == "Tutorial" {
//                let presentr = Presentr(presentationType: .fullScreen)
//                customPresentViewController(presentr, viewController: Onboard(), animated: true)
//            }
//        }
    }
    
    var items = ["Rate App", "Share", "Support"]
    var customization = ["Custom Base", "App Icon", "Accent Color", "Background"]
    var tutorial = ["Tutorial"]
    
    @objc func doneButtonPressed() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func setColors() {
        doneButton.tintColor = accentColor
        // bug in table view causes some cell that shouldn't show accessory views to show previous accessory view from different cell so we remove all accessory views first
        for cell in tableView.visibleCells {
            cell.accessoryView = nil
        }
        tableView.reloadData()
    }
    var doneButton = UIBarButtonItem()
    override func viewDidLoad() {
        super.viewDidLoad()
        doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonPressed))
        navigationItem.rightBarButtonItem = doneButton
        setColors()
        createAccentColorObserver(#selector(setColors))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }
}
