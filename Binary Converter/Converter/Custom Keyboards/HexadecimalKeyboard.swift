//
//  HexadecimalKeyboard.swift
//  TextToBinary
//
//  Created by Stacey Horowitz on 9/30/19.
//  Copyright © 2019 Michael Horowitz. All rights reserved.
//

import UIKit

fileprivate let buttonBackgroundColor = UIColor.tertiarySystemBackground
fileprivate let buttonBorderColor = UIColor.keyboardBorderColor
fileprivate let buttonLabelColor = UIColor.label

class DigitButton: UIButton {
    var digit: Int = 0
}
class LetterButton: UIButton{
    var letter: String = "a"
}

class HexadecimalKeyboard: UIView {
    weak var target: UIKeyInput?
    var deleteTimer = Timer()
    
    var numericButtons: [DigitButton] {
        (0...9).map {
            let button = DigitButton(type: .system)
            button.digit = $0
            button.setTitle("\($0)", for: .normal)
            button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title1)
            button.setTitleColor(buttonLabelColor, for: .normal)
            button.layer.borderWidth = 0.3
            button.layer.borderColor = buttonBorderColor.cgColor
            button.backgroundColor = buttonBackgroundColor
            button.accessibilityTraits = [.keyboardKey]
            button.addTarget(self, action: #selector(didTapDigitButton(_:)), for: .touchUpInside)
            return button
        }
    }
    var letterButtons: [LetterButton] {
        (Unicode.Scalar("a").value...Unicode.Scalar("f").value).map {
            let button = LetterButton(type: .system)
            button.letter = String(Unicode.Scalar($0)!)
            button.setTitle(String(Unicode.Scalar($0)!), for: .normal)
            button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title1)
            button.setTitleColor(buttonLabelColor, for: .normal)
            button.layer.borderWidth = 0.3
            button.layer.borderColor = buttonBorderColor.cgColor
            button.backgroundColor = buttonBackgroundColor
            button.accessibilityTraits = [.keyboardKey]
            button.addTarget(self, action: #selector(didTapLetterButton(_:)), for: .touchUpInside)
            return button
        }
    }
    var deleteButton: UIButton {
        let button = UIButton(type: .system)
        button.setTitle("⌫", for: .normal)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title1)
        button.setTitleColor(buttonLabelColor, for: .normal)
        button.layer.borderWidth = 0.3
        button.layer.borderColor = buttonBorderColor.cgColor
        button.backgroundColor = buttonBackgroundColor
        button.accessibilityTraits = [.keyboardKey]
        button.accessibilityLabel = "Delete"
        button.addTarget(self, action: #selector(didTapDeleteButton(_:)), for: .touchDown)
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(longTap(sender:)))
        button.addGestureRecognizer(longGesture)
        return button
    }
    var spaceButton: UIButton {
        let button = UIButton(type: .system)
        button.setTitle("space", for: .normal)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title1)
        button.setTitleColor(buttonLabelColor, for: .normal)
        button.layer.borderWidth = 0.3
        button.layer.borderColor = buttonBorderColor.cgColor
        button.backgroundColor = buttonBackgroundColor
        button.accessibilityTraits = [.keyboardKey]
        button.accessibilityLabel = "Space"
        button.addTarget(self, action: #selector(didTapSpaceButton(_:)), for: .touchUpInside)
        return button
    }
    func drawView() {
        self.subviews.forEach { subview in
            subview.removeFromSuperview()
        }
        configure()
    }
    init(target: UIKeyInput) {
        self.target = target
        super.init(frame: .zero)
        drawView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Actions

extension HexadecimalKeyboard {
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

private extension HexadecimalKeyboard {
    func configure() {
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addButtons()
    }
    
    func addButtons() {
        let stackView = createStackView(axis: .vertical)
        stackView.frame = bounds
        stackView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(stackView)
        
        do {
            let subStackView = createStackView(axis: .horizontal)
            stackView.addArrangedSubview(subStackView)
            for button in numericButtons {
                subStackView.addArrangedSubview(button)
            }
        }
        do {
            let subStackView = createStackView(axis: .horizontal)
            stackView.addArrangedSubview(subStackView)
            for button in letterButtons {
                subStackView.addArrangedSubview(button)
            }
            subStackView.addArrangedSubview(deleteButton)
        }
        let subStackView = createStackView(axis: .horizontal)
        stackView.addArrangedSubview(subStackView)
                
        subStackView.addArrangedSubview(spaceButton)
    }
    
    func createStackView(axis: NSLayoutConstraint.Axis) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = axis
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        return stackView
    }
}

extension HexadecimalKeyboard {
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        drawView()
    }
}
