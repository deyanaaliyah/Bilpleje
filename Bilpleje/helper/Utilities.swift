//
//  Utilities.swift
//  Bilpleje
//
//  Created by Dejan Love on 3/5/21.
//

import Foundation
import UIKit

class Utilities {
    static func styleTextField(_ textfield:UITextField) {
        textfield.layer.borderColor = UIColor.init(red: 53/255, green: 159/255, blue: 205/255, alpha: 1).cgColor
        
//        textfield.layer.cornerRadius = 8.0
//        textfield.layer.masksToBounds = true
//        textfield.layer.borderWidth = 1.0
        
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0, y: textfield.frame.height - 1, width: 324, height: 1.0)
        bottomLine.backgroundColor = UIColor.init(red: 53/255, green: 159/255, blue: 205/255, alpha: 1).cgColor
        textfield.borderStyle = UITextField.BorderStyle.none
        textfield.layer.addSublayer(bottomLine)
        
    }
    static func multilineTextfield(_ textfield:UITextField) {
        var frameRect = textfield.frame
        frameRect.size.height = 53
        textfield.frame = frameRect
    }
    static func passwordField(_ textfield:UITextField) {
        textfield.isSecureTextEntry = true
    }
    static func styleFilledButton(_ button:UIButton) {
        // Filled rounded corner style
        button.layer.cornerRadius = 8.0
    }
}
