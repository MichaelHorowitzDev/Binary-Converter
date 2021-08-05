//
//  AccentColorCollectionViewController.swift
//  TextToBinaryFree
//
//  Created by Stacey Horowitz on 8/30/20.
//  Copyright © 2020 Stacey Horowitz. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"
var defaultAccentColor = UIColor(red: 0/255, green: 110/255, blue: 236/255, alpha: 1)
var accentColor = UIColor(red: 0/255, green: 110/255, blue: 236/255, alpha: 1)

class AccentColorController: UICollectionViewController, UIColorPickerViewControllerDelegate, UIGestureRecognizerDelegate {
    
    var colorsData = [Data]()
    var colors = [UIColor]()
    
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        self.colors.append(self.colorPickerController.selectedColor)
        let indexPath = IndexPath(row: self.colors.count-1, section: 0)
        self.collectionView.insertItems(at: [indexPath])
        self.colorsData = self.colors.map {$0.encode()}
        UserDefaults.standard.set(self.colorsData, forKey: "accentColors")
    }
    
    let colorPickerController = UIColorPickerViewController()
    
    var currentIndex = 0
    
    @objc func setColors() {
        navigationController?.navigationBar.tintColor = accentColor
        let visibleItems = collectionView.indexPathsForVisibleItems
        collectionView.reloadItems(at: visibleItems)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.backgroundColor = .defaultBackground
        navigationItem.setTitle(title: "Accent Colors", subtitle: "Tap to change. Hold to delete")
        let lpgr: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gesture:)))
        lpgr.minimumPressDuration = 0.5
        lpgr.delegate = self
        self.collectionView?.addGestureRecognizer(lpgr)
        colorPickerController.delegate = self
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed))

        setColors()
        createAccentColorObserver(#selector(setColors))
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        if let accentColors = UserDefaults.standard.array(forKey: "accentColors") as? [Data] {
            for data in accentColors {
                if let color = UIColor.color(withData: data) {
                    colors.append(color)
                }
            }
        } else {
            colors.append(UIColor(red: 0/255, green: 110/255, blue: 236/255, alpha: 1))
            colorsData.append(UIColor(red: 0/255, green: 110/255, blue: 236/255, alpha: 1).encode())
            UserDefaults.standard.set(colorsData, forKey: "accentColors")
        }
        
        if let color = UserDefaults.standard.data(forKey: "accentColor") {
            accentColor = UIColor.color(withData: color)!
        }
        else {
            UserDefaults.standard.set(accentColor.encode(), forKey: "accentColor")
        }
    }
    
    @objc func addButtonPressed() {
        present(colorPickerController, animated: true, completion: nil)
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        print(colors[indexPath.row])
        print(cell.frame)
        let colorView = UIView(frame: CGRect(x: (cell.frame.width-cell.frame.width*0.8)/2, y: (cell.frame.height-cell.frame.height*0.8)/2, width: cell.frame.width*0.8, height: cell.frame.height*0.8))
        colorView.backgroundColor = colors[indexPath.row]
        colorView.layer.cornerRadius = colorView.frame.height/2
        colorView.layer.borderColor = UIColor.label.cgColor
        colorView.layer.borderWidth = 0.5
        colorView.tag = 100
        cell.addSubview(colorView)
    
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if colors[indexPath.row] == accentColor {
            cell.layer.borderColor = UIColor.label.cgColor
            cell.layer.borderWidth = 2
        }
        else {
            cell.layer.borderWidth = 0
            cell.layer.borderColor = UIColor.clear.cgColor
        }
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        accentColor = colors[indexPath.row]
        UserDefaults.standard.set(accentColor.encode(), forKey: "accentColor")
        collectionView.reloadData()
        updateAccentColor()
        self.navigationController?.navigationBar.tintColor = accentColor
    }
    @objc func handleLongPress(gesture: UILongPressGestureRecognizer) {
        if gesture.state != .began {
            return
        }
        let p = gesture.location(in: self.collectionView)
        if let indexPath = self.collectionView.indexPathForItem(at: p) {
            print(indexPath)
            if indexPath.row == 0 {
                return
            }
            let alert = UIAlertController(title: "Delete", message: "Would you like to delete?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
                if self.colors[indexPath.row] == accentColor {
                    accentColor = defaultAccentColor
                    UserDefaults.standard.set(accentColor.encode(), forKey: "accentColor")
                }
                self.colors.remove(at: indexPath.row)
                self.colorsData = self.colors.map {$0.encode()}
                UserDefaults.standard.set(self.colorsData, forKey: "accentColors")
                self.collectionView.deleteItems(at: [indexPath])
                
                self.updateAccentColor()
                self.navigationController?.navigationBar.tintColor = accentColor
                self.collectionView.reloadItems(at: [IndexPath(row: 0, section: 0)])
            }))
            present(alert, animated: true, completion: nil)
        } else {
            print("couldn't find index path")
        }
        return
    }
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        let visibleItems = collectionView.indexPathsForVisibleItems
        collectionView.reloadItems(at: visibleItems)
    }
}
