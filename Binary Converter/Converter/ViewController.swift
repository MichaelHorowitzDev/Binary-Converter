//
//  ViewControllerBasic.swift
//  TextToBinaryFree
//
//  Created by Michael Horowitz on 7/7/21.
//  Copyright © 2021 Stacey Horowitz. All rights reserved.
//

import UIKit
import PopupDialog
import Armchair
import SCLAlertView
class ViewController: UIViewController, UITextViewDelegate {
    func didSelectInputOrResultType(first: Bool, type: String, previousType: String) {
        if first {
            if type == secondInput.currentTitle! {
                secondInput.setTitle(previousType, for: .normal)
                pickerMenu()
            }
            if textInput.textColor == .lightGray {
                textInput.text = "Enter \(type)..."
            }
            setKeyboardType(type: type)
            if textInput.isFirstResponder {
                textInput.resignFirstResponder()
                textInput.becomeFirstResponder()
            }
        } else {
            if type == firstInput.currentTitle! {
                firstInput.setTitle(previousType, for: .normal)
                pickerMenu()
                if textInput.textColor == .lightGray {
                    textInput.text = "Enter \(previousType)..."
                }
                setKeyboardType(type: previousType)
                if textInput.isFirstResponder {
                    textInput.resignFirstResponder()
                    textInput.becomeFirstResponder()
                }
            }
        }
        performCalculation()
    }
    func setKeyboardType(type: String) {
        switch type {
        case "Binary":
            textInput.inputView = BinaryKeyboard(target: textInput)
        case "Hexadecimal":
            textInput.inputView = HexadecimalKeyboard(target: textInput)
        case "Integer":
            textInput.inputView = NumberKeyboard(target: textInput)
        case "Text":
            textInput.inputView = nil
            textInput.keyboardType = .default
            textInput.autocorrectionType = .yes
        default:
            if type.contains("Base-") {
                if let base = Int(type.removedSubrange("Base-")) {
                    if base <= 36 && base >= 2 {
                        textInput.inputView = CustomBaseKeyboard(target: textInput, base: base)
                    }
                }
            }
        }
    }
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var firstInput: UIButton!
    @IBOutlet weak var secondInput: UIButton!
    @IBOutlet var textInput: UITextView!
    @IBOutlet var resultTextView: UITextView!
    @IBOutlet var copyButton: UIButton!
    @IBOutlet weak var pasteButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var swapButton: UIButton!
    @IBOutlet var textInputWidth: NSLayoutConstraint!
    @IBOutlet var resultTextWidth: NSLayoutConstraint!
    @IBOutlet var firstInputLeading: NSLayoutConstraint!
    @IBOutlet var copyButtonTrailing: NSLayoutConstraint!
    @IBOutlet weak var pasteButtonLeading: NSLayoutConstraint!
    @IBOutlet weak var secondInputTrailing: NSLayoutConstraint!
    @IBOutlet var textInputLeading: NSLayoutConstraint!
    @IBOutlet weak var resultTextViewTrailing: NSLayoutConstraint!
    var pickerList = ["Text", "Binary", "Hexadecimal", "Integer"]
    var customBase = 2
    @objc func setColors() {
        firstInput.backgroundColor = accentColor
        secondInput.backgroundColor = accentColor
        copyButton.backgroundColor = accentColor
        pasteButton.backgroundColor = accentColor
        settingsButton.imageView?.tintColor = accentColor
        swapButton.imageView?.tintColor = accentColor
        label.textColor = accentColor
        textInput.layer.borderColor = accentColor.cgColor
        resultTextView.layer.borderColor = accentColor.cgColor
        firstInput.setTitleColor(firstInput.backgroundColor!.isLight ? .white : .black, for: .normal)
        secondInput.setTitleColor(secondInput.backgroundColor!.isLight ? .white : .black, for: .normal)
        UIView.performWithoutAnimation {
            copyButton.setTitleColor(copyButton.backgroundColor!.isLight ? .white : .black, for: .normal)
            copyButton.layoutIfNeeded()
            pasteButton.setTitleColor(pasteButton.backgroundColor!.isLight ? .white : .black, for: .normal)
            pasteButton.layoutIfNeeded()
        }
    }
    func setConstraints(size: CGSize) {
        // 116 is the empty space that is set by constraints
        let textViewWidth = (size.width-116)/2
        firstInputLeading.constant = textInputLeading.constant + (textViewWidth-firstInput.frame.width)/2
        secondInputTrailing.constant = abs(resultTextViewTrailing.constant) + abs(textViewWidth-secondInput.frame.width)/2
        copyButtonTrailing.constant = abs(resultTextViewTrailing.constant) + abs(textViewWidth-copyButton.frame.width)/2
        pasteButtonLeading.constant = textInputLeading.constant + (textViewWidth-pasteButton.frame.width)/2
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        setConstraints(size: size)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.layoutIfNeeded()
        createAccentColorObserver(#selector(setColors))
        createBackgroundObserver(#selector(setBackground))
        createCustomBaseObserver(#selector(setCustomBase))
        setConstraints(size: view.frame.size)
        textInput.delegate = self
        if menuConfig != nil && menuConfig?.count == 2 {
            let menuConfig = menuConfig!
            firstInput.setTitle(menuConfig[0], for: .normal)
            secondInput.setTitle(menuConfig[1], for: .normal)
            textInput.text = "Enter \(menuConfig[0])..."
            setKeyboardType(type: menuConfig[0])
        } else {
            firstInput.setTitle("Text", for: .normal)
            secondInput.setTitle("Binary", for: .normal)
            textInput.text = "Enter Text..."
        }
        textInput.textColor = UIColor.lightGray
        firstInput.showsMenuAsPrimaryAction = true
        secondInput.showsMenuAsPrimaryAction = true
        firstInput.layer.cornerRadius = 5
        secondInput.layer.cornerRadius = 5
        copyButton.layer.cornerRadius = 5
        pasteButton.layer.cornerRadius = 5
        firstInput.clipsToBounds = true
        secondInput.clipsToBounds = true
        textInput.layer.borderWidth = 1
        resultTextView.layer.borderWidth = 1
        textInput.layer.cornerRadius = 6
        resultTextView.layer.cornerRadius = 6
        let symbolConfiguration = UIImage.SymbolConfiguration(weight: .heavy)
        let swapSymbol = UIImage(systemName: "arrow.left.arrow.right", withConfiguration: symbolConfiguration)
        swapButton.setImage(swapSymbol, for: .normal)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        addToolbar()
        setCustomBase()
        setColors()
        setBackground()
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if let cursorPosition = textInput.selectedTextRange?.start {
                let caretPosition: CGRect = textInput.caretRect(for: cursorPosition)
                let textInputY = textInput.frame.origin.y+CGFloat.minimum(textInput.frame.height, caretPosition.origin.y)+40
                let keyboardY = self.view.frame.maxY-keyboardSize.height
                let keyboardShift = textInputY-keyboardY
                if textInput.isFirstResponder {
                    if self.view.frame.origin.y == 0 && keyboardShift > 0 {
                        self.view.frame.origin.y -= keyboardShift
                    }
                }
            }
        }
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
    }
    @objc func addToolbar() {
        let toolbar = UIToolbar()
        toolbar.items = [UIBarButtonItem.flexibleSpace(), UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(hideKeyboard))]
        toolbar.sizeToFit()
        textInput.inputAccessoryView = toolbar
    }
    @objc func hideKeyboard() {
        textInput.resignFirstResponder()
    }
    @objc func setCustomBase() {
        pickerList = ["Text", "Binary", "Hexadecimal", "Integer"]
        if isCustomBase {
            if let baseArray = customBaseArray {
                pickerList.append(contentsOf: baseArray)
            }
        }
        pickerMenu()
    }
    
    //sets up custom backgroud if user has selected one
    @objc func setBackground() {
        //remove current background
        for subview in self.view.subviews {
            if subview.tag == 100 || subview.tag == 101 {
                subview.removeFromSuperview()
            }
        }
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        imageView.tag = 101
        imageView.contentMode = .scaleAspectFill
        //check for backgroundData in userdefaults
        if let data = UserDefaults.standard.data(forKey: "backgroundData") {
            //check if data is color
            if let color = UIColor.color(withData: data) {
                let colorView = UIView(frame: view.frame)
                colorView.tag = 100
                colorView.backgroundColor = color
                self.view.insertSubview(colorView, at: 0)
            } else if let file = String(data: data, encoding: .utf8) {
                //check if data is url that points to image
                if let image = UIImage.loadImageFromDiskWith(fileName: file) {
                    imageView.image = image
                    self.view.insertSubview(imageView, at: 0)
                }
            }
        }
    }
    func pickerMenu() {
        for input in [firstInput, secondInput] {
            let input = input!
            let menu = UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children:
                pickerList.map({ item in
                var image: UIImage?
                if item == input.currentTitle! {
                    image = UIImage(systemName: "checkmark")
                } else {
                    if item == "Custom Base" && !pickerList.contains(input.currentTitle!) {
                        image = UIImage(systemName: "checkmark")
                    }
                }
                return UIAction(title: item, image: image) { _ in
                    let previousType = input.currentTitle!
                    if item == "Custom Base" {
                        var item = item
                        showCustomBaseAlert { base in
                            if base != nil {
                                item = "Base-\(base!)"
                                input.setTitle(item, for: .normal)
                                self.pickerMenu()
                                self.didSelectInputOrResultType(first: input == self.firstInput, type: item, previousType: previousType)
                            }
                        }
                    } else {
                        input.setTitle(item, for: .normal)
                        self.pickerMenu()
                        self.didSelectInputOrResultType(first: input == self.firstInput, type: item, previousType: previousType)
                    }
                    }
                })
            )
            input.menu = menu
        }
        saveMenuConfig()
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textInput.textColor == UIColor.lightGray {
            textInput.text = ""
            textInput.textColor = .label
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textInput.text.isEmpty {
            textInput.text = "Enter \(firstInput.currentTitle!)..."
            textInput.textColor = UIColor.lightGray
        }
    }
    func textViewDidChange(_ textView: UITextView) {
        performCalculation()
        scrollTextViewToBottom(textView: resultTextView)
        UIView.performWithoutAnimation {
            textInput.resignFirstResponder()
            textInput.becomeFirstResponder()
        }
    }
    func scrollTextViewToBottom(textView: UITextView) {
        if textView.text.count > 0 {
            let location = textView.text.count - 1
            let bottom = NSMakeRange(location, 1)
            textView.scrollRangeToVisible(bottom)
        }
    }
    @IBAction func settingsButtonPressed(_ sender: UIButton) {
        textInput.resignFirstResponder()
        textInput.inputView = nil
        performSegue(withIdentifier: "settings", sender: self)
    }
    @IBAction func copyButtonPressed(_ sender: UIButton) {
        textInput.resignFirstResponder()
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        if resultTextView.text != "" {
            UIPasteboard.general.string = resultTextView.text
        }
        
        let title = "COPIED"
        let message = "Text was copied to clipboard"
        let popup = PopupDialog(title: title, message: message, completion: {
            print("done")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                Armchair.showPromptIfNecessary()
            }
        })
        popup.transitionStyle = PopupDialogTransitionStyle.zoomIn
        let pv = PopupDialogDefaultView.appearance()
        pv.backgroundColor = .defaultBackground
        pv.titleColor = .label
        self.present(popup, animated: true, completion: nil)
    }
    @IBAction func pasteButtonPressed(_ sender: UIButton) {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        if UIPasteboard.general.string != nil && UIPasteboard.general.string != "" {
            textInput.text = UIPasteboard.general.string
            textInput.textColor = .label
            performCalculation()
        }
    }
    @IBAction func swapButtonPressed(_ sender: UIButton) {
        let firstInputText = firstInput.currentTitle!
        firstInput.setTitle(secondInput.currentTitle!, for: .normal)
        secondInput.setTitle(firstInputText, for: .normal)
        if textInput.textColor == .lightGray {
            textInput.text = "Enter \(firstInput.currentTitle!)..."
        }
        setKeyboardType(type: firstInput.currentTitle!)
        pickerMenu()
        performCalculation()
        if textInput.isFirstResponder {
            textInput.resignFirstResponder()
            textInput.becomeFirstResponder()
        }
    }
    
    //performCalculation
    func performCalculation() {
        if textInput.textColor == .lightGray {
            return
        }
        resultTextView.text = converter(input: textInput.text, inputType: firstInput.currentTitle!, resultType: secondInput.currentTitle!)
    }
}

extension ViewController {
    func saveMenuConfig() {
        UserDefaults.standard.set([firstInput.currentTitle!, secondInput.currentTitle!], forKey: "menuConfig")
    }
    var menuConfig: [String]? {
        UserDefaults.standard.stringArray(forKey: "menuConfig") ?? nil
    }
}
