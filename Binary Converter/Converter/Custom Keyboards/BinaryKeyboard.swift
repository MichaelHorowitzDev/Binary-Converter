//
//  CustomKeyboard.swift
//  TextToBinary
//
//  Created by Stacey Horowitz on 9/29/19.
//  Copyright © 2019 Michael Horowitz. All rights reserved.
//

import UIKit

fileprivate let buttonBackgroundColor = UIColor.tertiarySystemBackground
fileprivate let buttonBorderColor = UIColor.keyboardBorderColor
fileprivate let buttonLabelColor = UIColor.label

class BinaryKeyboard: UIView {
    weak var target: UIKeyInput?
    var deleteTimer = Timer()
    var firstButton: UIButton {
        let button = UIButton(type: .system)
        button.setTitle("0", for: .normal)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title1)
        button.setTitleColor(buttonLabelColor, for: .normal)
        button.layer.borderWidth = 0.3
        button.layer.borderColor = buttonBorderColor.cgColor
        button.backgroundColor = buttonBackgroundColor
        button.accessibilityTraits = [.keyboardKey]
        button.accessibilityLabel = "0"
        button.addTarget(self, action: #selector(didTapOneButton(_:)), for: .touchUpInside)
        return button
    }
    var secondButton: UIButton {
        let button = UIButton(type: .system)
        button.setTitle("1", for: .normal)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title1)
        button.setTitleColor(buttonLabelColor, for: .normal)
        button.layer.borderWidth = 0.3
        button.layer.borderColor = buttonBorderColor.cgColor
        button.backgroundColor = buttonBackgroundColor
        button.accessibilityTraits = [.keyboardKey]
        button.accessibilityLabel = "1"
        button.addTarget(self, action: #selector(didTapTwoButton(_:)), for: .touchUpInside)
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
        button.accessibilityLabel = ""
        button.addTarget(self, action: #selector(didTapSpaceBar(_:)), for: .touchUpInside)
        return button
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

extension BinaryKeyboard {
    @objc func didTapOneButton(_ sender: UIButton) {
        target?.insertText("\(sender.currentTitle!)")
    }
    @objc func didTapTwoButton(_ sender: UIButton) {
        target?.insertText("\(sender.currentTitle!)")
    }
    @objc func didTapSpaceBar(_ sender: UIButton) {
        target?.insertText(" ")
    }
    
    @objc func didTapDeleteButton(_ sender: UIButton) {
        target?.deleteBackward()
    }
    
    @objc func longTap(sender: UIGestureRecognizer){
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

private extension BinaryKeyboard {
    func configure() {
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addButtons()
    }
    
    func addButtons() {
        let stackView = createStackView(axis: .vertical)
        stackView.frame = bounds
        stackView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(stackView)
        
        let subStackView = createStackView(axis: .horizontal)
        stackView.addArrangedSubview(subStackView)
                
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(longTap(sender:)))
        deleteButton.addGestureRecognizer(longGesture)
        subStackView.addArrangedSubview(firstButton)
        subStackView.addArrangedSubview(secondButton)
        subStackView.addArrangedSubview(deleteButton)
        stackView.addArrangedSubview(spaceButton)
    }
    
    func createStackView(axis: NSLayoutConstraint.Axis) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = axis
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        return stackView
    }
}

extension BinaryKeyboard {
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        drawView()
    }
}
