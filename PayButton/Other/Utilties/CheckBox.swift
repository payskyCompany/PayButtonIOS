//
//  CheckBox.swift
//  PayButton
//
//  Created by PaySky105 on 19/06/2023.
//  Copyright © 2023 PaySky. All rights reserved.
//

import Foundation
import UIKit

protocol CheckBoxDelegate: AnyObject {
    func didTapCheckBox(_ sender: CheckBox, isChecked: Bool)
}

class CheckBox: UIButton {
    
    // Images
    let checkedImage = UIImage(systemName: "checkmark.square.fill")! as UIImage
    let uncheckedImage = UIImage(systemName: "square")! as UIImage
    
    // Bool property
    var isChecked: Bool = false {
        didSet {
            if isChecked == true {
                self.setImage(checkedImage, for: UIControl.State.normal)
            } else {
                self.setImage(uncheckedImage, for: UIControl.State.normal)
            }
        }
    }
    
    // Delegate
    weak var delegate: CheckBoxDelegate?
    
    override func awakeFromNib() {
        self.addTarget(self, action:#selector(buttonClicked(sender:)), for: UIControl.Event.touchUpInside)
        self.isChecked = false
    }
    
    @objc func buttonClicked(sender: UIButton) {
        if sender == self {
            isChecked = !isChecked
            delegate?.didTapCheckBox(self, isChecked: self.isChecked)
        }
    }
    
    
}
