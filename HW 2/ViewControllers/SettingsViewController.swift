//
//  ViewController.swift
//  HW 2
//
//  Created by Alexey Efimov on 12.06.2018.
//  Copyright © 2018 Alexey Efimov. All rights reserved.
//

import UIKit

final class SettingsViewController: UIViewController {
    
    @IBOutlet var colorView: UIView!
    
    @IBOutlet var redLabel: UILabel!
    @IBOutlet var greenLabel: UILabel!
    @IBOutlet var blueLabel: UILabel!
    
    @IBOutlet var redSlider: UISlider!
    @IBOutlet var greenSlider: UISlider!
    @IBOutlet var blueSlider: UISlider!
    
    @IBOutlet var redTextField: UITextField!
    @IBOutlet var greenTextField: UITextField!
    @IBOutlet var blueTextField: UITextField!
    
    weak var delegate: SettingsViewControllerDelegate?
    
    var backgroundColor: UIColor!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        colorView.layer.cornerRadius = 15
        updateValueSlider()
        
        colorView.backgroundColor = backgroundColor
        
        redTextField.delegate = self
        greenTextField.delegate = self
        blueTextField.delegate = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    @IBAction func setupMainScreen(_ sender: UIButton) {
        guard let redTF = redTextField.text, let greenTF = greenTextField.text, let blueTF = blueTextField.text, !redTF.isEmpty, !greenTF.isEmpty, !blueTF.isEmpty else {
            showAlert(
                withTitle: "Text field is empty",
                andMessage: "Please enter a number from 0 to 1 rounded to two decimal places."
            )
            return
        }
        delegate?.updateBackgroundColor(colorView.backgroundColor ?? .white)
        dismiss(animated: true)
    }
    @IBAction func sliderAction(_ sender: UISlider) {
        setColor()
        
        switch sender {
        case redSlider:
            redLabel.text = string(from: redSlider)
            redTextField.text = string(from: redSlider)
        case greenSlider:
            greenLabel.text = string(from: greenSlider)
            greenTextField.text = string(from: greenSlider)
        default:
            blueLabel.text = string(from: blueSlider)
            blueTextField.text = string(from: blueSlider)
        }
    }
    
    private func setColor() {
        colorView.backgroundColor = UIColor(
            red: redSlider.value.cgFloat(),
            green: greenSlider.value.cgFloat(),
            blue: blueSlider.value.cgFloat(),
            alpha: 1
        )
    }
    
    private func updateValueSlider() {
        let color = CIColor(color: backgroundColor)
        redSlider.value = Float(color.red)
        greenSlider.value = Float(color.green)
        blueSlider.value = Float(color.blue)
        
        redTextField.text = string(from: redSlider)
        greenTextField.text = string(from: greenSlider)
        blueTextField.text = string(from: blueSlider)
    }
    
    private func string(from slider: UISlider) -> String {
        String(format: "%.2f", slider.value)
    }
    
    private func showAlert(withTitle title: String, andMessage message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        }
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}

extension Float {
    func cgFloat() -> CGFloat {
        CGFloat(self)
    }
}

extension SettingsViewController: UITextFieldDelegate {
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text, let value = Float(text) else {
            showAlert(
                withTitle: "Wrong format",
                andMessage: "Please enter a number from 0 to 1 rounded to two decimal places."
            ) {
                textField.text = ""
            }
            return
        }
        
        let textFieldPattern = #"^(?:0(?:\.\d{1,2})?|1(?:\.0{1,2})?)$"#
        let isTextFieldValid = NSPredicate(format: "SELF MATCHES %@", textFieldPattern)
            .evaluate(with: text)
        
        if isTextFieldValid {
            if textField == redTextField {
                redSlider.value = value
            } else if textField == greenTextField {
                greenSlider.value = value
            } else if textField == blueTextField {
                blueSlider.value = value
            }
            setColor()
        } else {
            showAlert(
                withTitle: "Wrong format",
                andMessage: "Please enter a number from 0 to 1 rounded to two decimal places."
            ) {
                textField.text = ""
            }
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
