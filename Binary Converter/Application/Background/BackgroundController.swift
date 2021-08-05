//
//  BackgroundCollectionViewController.swift
//  TextToBinaryFree
//
//  Created by Stacey Horowitz on 8/31/20.
//  Copyright © 2020 Stacey Horowitz. All rights reserved.
//

import UIKit
private let reuseIdentifier = "Cell"

class HeaderView: UIView {
    
}
class BackgroundController: UICollectionViewController, UIGestureRecognizerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIColorPickerViewControllerDelegate {
    
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        self.backgroundDataArray.append(self.colorPickerController.selectedColor.encode())
        self.backgroundImages = []
        self.updateBackgroundImages()
        UserDefaults.standard.set(Array(self.backgroundDataArray.dropFirst()), forKey: "backgroundDataArray")
        let indexPath = IndexPath(row: self.backgroundDataArray.count-1, section: 0)
        self.collectionView.insertItems(at: [indexPath])
    }
    
    var backgroundDataArray = [Data]()
    var colors = [UIColor]()
    var backgroundData = Data()
    var backgroundImages = [UIImage]()
        
    let colorPickerController = UIColorPickerViewController()
    
    var currentIndex = 0
    
    @objc func setColors() {
        navigationController?.navigationBar.tintColor = accentColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.backgroundColor = .defaultBackground
        navigationItem.setTitle(title: "Background", subtitle: "Tap to change. Hold to delete")
        let lpgr: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gesture:)))
        lpgr.minimumPressDuration = 0.5
        lpgr.delegate = self
        self.collectionView?.addGestureRecognizer(lpgr)
        colorPickerController.delegate = self
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed))
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        setColors()
        createAccentColorObserver(#selector(setColors))
        
        if let backgroundColors = UserDefaults.standard.array(forKey: "backgroundDataArray") as? [Data] {
            backgroundDataArray = backgroundColors
            for data in backgroundColors {
                if let color = UIColor.color(withData: data) {
                    colors.append(color)
                }
            }
        }
        backgroundDataArray.insert(UIColor.defaultBackground.encode(), at: 0)
        updateBackgroundImages()
        
        if let data = UserDefaults.standard.data(forKey: "backgroundData") {
            backgroundData = data
        } else {
            backgroundData = backgroundDataArray[0]
        }
        currentIndex = backgroundDataArray.firstIndex(of: backgroundData) ?? 0
    }
    
    func updateBackgroundImages() {
        backgroundImages = []
        for data in backgroundDataArray {
            print("data", data)
            if let color = UIColor.color(withData: data) {
                backgroundImages.append(color.image())
            } else if let file = String(data: data, encoding: .utf8) {
                print("file", file)
                if let image = UIImage.loadImageFromDiskWith(fileName: file+"thumbnail") {
                    backgroundImages.append(image)
                }
            } else {
                backgroundDataArray.remove(at: backgroundDataArray.firstIndex(of: data)!)
            }
        }
    }
    
    @objc func addButtonPressed() {
        var alertStyle = UIAlertController.Style.actionSheet
        if UIDevice.current.userInterfaceIdiom == .pad {
            alertStyle = .alert
        }
        let alert = UIAlertController(title: "Add Background", message: "What type of background do you want to add?", preferredStyle: alertStyle)
        alert.addAction(UIAlertAction(title: "Color", style: .default, handler: { (action) in
            self.present(self.colorPickerController, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Image", style: .default, handler: { (action) in
            let imagePickerController = UIImagePickerController()
            imagePickerController.sourceType = .photoLibrary
            imagePickerController.delegate = self
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let uuid = UUID().uuidString
        let scale = UIScreen.main.scale
        guard let image = info[.originalImage] as? UIImage else { return }
        dismiss(animated: true) {
            print("done")
        }
        let smallerImage = image.resizedImageWith(targetSize: CGSize(width: 1080/scale, height: 1920/scale))
        let thumbnail = image.resizedImageWith(targetSize: CGSize(width: 150/scale, height: 150/scale))
        smallerImage.saveImage(imageName: uuid)
        thumbnail.saveImage(imageName: uuid+"thumbnail")
        backgroundDataArray.append(uuid.data(using: .utf8)!)
        UserDefaults.standard.set(Array(backgroundDataArray.dropFirst()), forKey: "backgroundDataArray")
        updateBackgroundImages()
        collectionView.insertItems(at: [IndexPath(item: backgroundDataArray.count-1, section: 0)])
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return backgroundDataArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        let imageView = UIImageView(frame: CGRect(x: (cell.frame.width-cell.frame.width*0.8)/2, y: (cell.frame.height-cell.frame.height*0.8)/2, width: cell.frame.width*0.8, height: cell.frame.height*0.8))
        imageView.contentMode = .scaleAspectFill
        imageView.image = backgroundImages[indexPath.row]
        imageView.layer.cornerRadius = imageView.frame.height/2
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor.label.cgColor
        imageView.layer.borderWidth = 0.5
        imageView.tag = 100
        cell.addSubview(imageView)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if currentIndex == indexPath.row {
            cell.layer.borderColor = UIColor.label.cgColor
            cell.layer.borderWidth = 2
        }
        else {
            cell.layer.borderWidth = 0
            cell.layer.borderColor = UIColor.clear.cgColor
        }
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        backgroundData = backgroundDataArray[indexPath.row]
        if indexPath.row == 0 {
            UserDefaults.standard.removeObject(forKey: "backgroundData")
        } else {
            UserDefaults.standard.set(backgroundData, forKey: "backgroundData")
        }
        currentIndex = indexPath.row
        collectionView.reloadData()
        updateBackground()
    }
    @objc func handleLongPress(gesture: UILongPressGestureRecognizer) {
        if gesture.state != .began {
            return
        }
        
        let p = gesture.location(in: self.collectionView)
        if let indexPath = self.collectionView.indexPathForItem(at: p) {
            if indexPath.row == 0 {
                return
            }
            let alert = UIAlertController(title: "Delete", message: "Would you like to delete?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
                if let filename = String(data: self.backgroundDataArray[indexPath.row], encoding: .utf8) {
                    UIImage.deleteImageFromDiskWith(fileName: filename)
                    UIImage.deleteImageFromDiskWith(fileName: filename+"thumbnail")
                }
                if self.backgroundDataArray[indexPath.row] == self.backgroundData {
                    self.backgroundData = self.backgroundDataArray[0]
                    UserDefaults.standard.removeObject(forKey: "backgroundData")
                }
                self.backgroundDataArray.remove(at: indexPath.row)
                self.backgroundImages = []
                self.updateBackgroundImages()
                UserDefaults.standard.set(Array(self.backgroundDataArray.dropFirst()), forKey: "backgroundDataArray")
                self.collectionView.deleteItems(at: [indexPath])
                self.collectionView.reloadItems(at: [IndexPath(row: 0, section: 0)])
                self.updateBackground()
            }))
            present(alert, animated: true, completion: nil)
        } else {
            print("couldn't find index path")
        }
        return
    }
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        backgroundDataArray[0] = UIColor.defaultBackground.encode()
        updateBackgroundImages()
        let visibleItems = collectionView.indexPathsForVisibleItems
        collectionView.reloadItems(at: visibleItems)
    }
}
