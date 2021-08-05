//
//  HexadecimalKeyboard.swift
//  TextToBinary
//
//  Created by Stacey Horowitz on 9/30/19.
//  Copyright © 2019 Michael Horowitz. All rights reserved.
//

import UIKit

private let darkMode = false
class CustomBaseKeyboard: UIView {
    weak var target: UIKeyInput?
    var customBase: Int!
    var deleteTimer = Timer()
    
    var numericButtons: [DigitButton] = (0...9).map {
        let button = DigitButton(type: .system)
        button.digit = $0
        button.setTitle("\($0)", for: .normal)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title1)
        darkMode ? button.setTitleColor(.white, for: .normal) : button.setTitleColor(.black, for: .normal)
        button.layer.borderWidth = 0.3
        button.layer.borderColor = darkMode ? UIColor.lightGray.cgColor : UIColor.darkGray.cgColor
        button.layer.backgroundColor = darkMode ? UIColor(red: 28.0/255, green: 28.0/255, blue: 30.0/255, alpha: 1).cgColor :  UIColor.white.cgColor
        button.accessibilityTraits = [.keyboardKey]
        button.addTarget(self, action: #selector(didTapDigitButton(_:)), for: .touchUpInside)
        return button
    }
    var letterButtons: [LetterButton] = (Unicode.Scalar("a").value...Unicode.Scalar("z").value).map {
        let button = LetterButton(type: .system)
        button.letter = String(Unicode.Scalar($0)!)
        button.setTitle(String(Unicode.Scalar($0)!), for: .normal)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title1)
        darkMode ? button.setTitleColor(.white, for: .normal) : button.setTitleColor(.black, for: .normal)
        button.layer.borderWidth = 0.3
        button.layer.borderColor = darkMode ? UIColor.lightGray.cgColor : UIColor.darkGray.cgColor
        button.layer.backgroundColor = darkMode ? UIColor(red: 28.0/255, green: 28.0/255, blue: 30.0/255, alpha: 1).cgColor :  UIColor.white.cgColor
        button.accessibilityTraits = [.keyboardKey]
        button.addTarget(self, action: #selector(didTapLetterButton(_:)), for: .touchUpInside)
        return button
    }
    
    var deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("⌫", for: .normal)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title1)
        darkMode ? button.setTitleColor(.white, for: .normal) : button.setTitleColor(.black, for: .normal)
        button.layer.borderWidth = 0.3
        button.layer.borderColor = darkMode ? UIColor.lightGray.cgColor : UIColor.darkGray.cgColor
        button.layer.backgroundColor = darkMode ? UIColor(red: 28.0/255, green: 28.0/255, blue: 30.0/255, alpha: 1).cgColor :  UIColor.white.cgColor
        button.accessibilityTraits = [.keyboardKey]
        button.accessibilityLabel = "Delete"
        button.addTarget(self, action: #selector(didTapDeleteButton(_:)), for: .touchDown)
        return button
    }()
    var spaceButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("space", for: .normal)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title1)
        darkMode ? button.setTitleColor(.white, for: .normal) : button.setTitleColor(.black, for: .normal)
        button.layer.borderWidth = 0.3
        button.layer.borderColor = darkMode ? UIColor.lightGray.cgColor : UIColor.darkGray.cgColor
        button.layer.backgroundColor = darkMode ? UIColor(red: 28.0/255, green: 28.0/255, blue: 30.0/255, alpha: 1).cgColor :  UIColor.white.cgColor
        button.accessibilityTraits = [.keyboardKey]
        button.accessibilityLabel = "Space"
        button.addTarget(self, action: #selector(didTapSpaceButton(_:)), for: .touchUpInside)
        return button
    }()
    init(target: UIKeyInput, base: Int) {
        self.target = target
        self.customBase = base
        super.init(frame: .zero)
        configure(base: customBase)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Actions

extension CustomBaseKeyboard {
    @objc func didTapDigitButton(_ sender: DigitButton) {
        target?.insertText("\(sender.digit)")
    }
    @objc func didTapLetterButton(_ sender: LetterButton) {
        target?.insertText("\(sender.letter)")
    }
    @objc func didTapDeleteButton(_ sender: DigitButton) {
        target?.deleteBackward()
    }
    @objc func didTapSpaceButton(_ sender: DigitButton) {
        target?.insertText(" ")
    }
    @objc func longTap(sender: UIGestureRecognizer) {
        print("Long tap")
        if sender.state == .ended {
            deleteTimer.invalidate()
            print("UIGestureRecognizerStateEnded")
            //Do Whatever You want on End of Gesture
        }
        else if sender.state == .began {
            deleteTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { (timer) in
                self.target?.deleteBackward()
            })
            print("UIGestureRecognizerStateBegan.")
            //Do Whatever You want on Began of Gesture
        }
    }
}

// MARK: - Private initial configuration methods

private extension CustomBaseKeyboard {
    func configure(base: Int) {
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addButtons(base: base)
    }
    
    func addButtons(base: Int) {
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(longTap(sender:)))
        deleteButton.addGestureRecognizer(longGesture)
        let stackView = createStackView(axis: .vertical)
        stackView.frame = bounds
        stackView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(stackView)
        
//        for row in 0 ..< 3 {
//            let subStackView = createStackView(axis: .horizontal)
//            stackView.addArrangedSubview(subStackView)
//
//            for column in 0 ..< 3 {
//                subStackView.addArrangedSubview(numericButtons[row * 3 + column + 1])
//            }
//        }
        for _ in 0...0 {
            let subStackView = createStackView(axis: .horizontal)
            stackView.addArrangedSubview(subStackView)
            for column in 0 ... 9 {
                subStackView.addArrangedSubview(numericButtons[column])
            }
        }
        for _ in 0...0{
            let subStackView = createStackView(axis: .horizontal)
            stackView.addArrangedSubview(subStackView)
            for column in 0 ... 5{
                subStackView.addArrangedSubview(letterButtons[column])
            }
            subStackView.addArrangedSubview(deleteButton)
        }
        let subStackView = createStackView(axis: .horizontal)
        stackView.addArrangedSubview(subStackView)
        
        let blank = UIView()
        blank.layer.borderWidth = 0.5
        blank.layer.borderColor = UIColor.darkGray.cgColor
        
        subStackView.addArrangedSubview(spaceButton)
        //subStackView.addArrangedSubview(numericButtons[3])
        //subStackView.addArrangedSubview(deleteButton)
    }
    
    func createStackView(axis: NSLayoutConstraint.Axis) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = axis
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        return stackView
    }
}
