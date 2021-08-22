//
//  NumberKeyboard.swift
//  TextToBinary
//
//  Created by Stacey Horowitz on 9/30/19.
//  Copyright © 2019 Michael Horowitz. All rights reserved.
//

import UIKit

fileprivate let buttonBackgroundColor = UIColor.tertiarySystemBackground
fileprivate let buttonBorderColor = UIColor.keyboardBorderColor
fileprivate let buttonLabelColor = UIColor.label

class numberButton: UIButton {
    var digit: Int = 0
}

class NumberKeyboard: UIView {
    weak var target: UIKeyInput?
    var deleteTimer = Timer()
    var numericButtons: [numberButton] {
        (0...9).map {
            let button = numberButton(type: .system)
            button.digit = $0
            button.setTitle("\($0)", for: .normal)
            button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title1)
            button.setTitleColor(buttonLabelColor, for: .normal)
            button.layer.borderWidth = 0.3
            button.layer.borderColor = buttonBorderColor.cgColor
            button.backgroundColor = buttonBackgroundColor
            button.accessibilityTraits = [.keyboardKey]
            button.addTarget(self, action: #selector(didTapnumberButton(_:)), for: .touchUpInside)
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

extension NumberKeyboard {
    @objc func didTapnumberButton(_ sender: numberButton) {
        target?.insertText("\(sender.digit)")
    }
    @objc func didTapSpaceButton(_ sender: numberButton) {
        target?.insertText(" ")
    }
    
    @objc func didTapDeleteButton(_ sender: numberButton) {
        target?.deleteBackward()
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

private extension NumberKeyboard {
    func configure() {
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addButtons()
    }
    
    func addButtons() {
        let stackView = createStackView(axis: .vertical)
        stackView.frame = bounds
        stackView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(stackView)
        
        for row in 0 ..< 3 {
            let subStackView = createStackView(axis: .horizontal)
            stackView.addArrangedSubview(subStackView)
            
            for column in 0 ..< 3 {
                subStackView.addArrangedSubview(numericButtons[row * 3 + column + 1])
            }
        }
        
        let subStackView = createStackView(axis: .horizontal)
        stackView.addArrangedSubview(subStackView)
        
        subStackView.addArrangedSubview(spaceButton)
        subStackView.addArrangedSubview(numericButtons[0])
        subStackView.addArrangedSubview(deleteButton)
    }
    
    func createStackView(axis: NSLayoutConstraint.Axis) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = axis
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        return stackView
    }
}

extension NumberKeyboard {
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        drawView()
    }
}
