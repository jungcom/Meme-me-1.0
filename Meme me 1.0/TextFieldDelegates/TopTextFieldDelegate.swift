//
//  TopTextFieldDelegate.swift
//  ImagePickerPractice
//
//  Created by Anthony Lee on 5/24/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import Foundation
import UIKit

class TopTextFieldDelegate: NSObject, UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == "TOP" || textField.text == "BOTTOM"{
            textField.text = ""
        }
    }
    
}
