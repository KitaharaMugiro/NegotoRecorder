//
//  SensibilityButton.swift
//  NegotoRecorder
//
//  Created by kitaharamugirou on 2020/06/28.
//  Copyright © 2020 kitaharamugirou. All rights reserved.
//

import Foundation
import UIKit
import EMTNeumorphicView

protocol SensibilityButtonDelegate: class {
    func onTapped(type: SensibilityType)
}

class SensibilityButton:NSObject  {
    var button : EMTNeumorphicButton
    var type : SensibilityType
    weak var delegate :SensibilityButtonDelegate? = nil

    init(type : SensibilityType) {
        let button = EMTNeumorphicButton(type: .custom)
        button.neumorphicLayer?.cornerRadius = 12
        button.neumorphicLayer?.elementDepth = 7
        self.button = button
        self.type = type
        super.init()
        self.setText(type: type)
    }
    
    private func setText(type : SensibilityType) {
        self.button.setTitle(type.getText(), for: .normal)
        self.button.setTitleColor(MyColors.gray, for: .normal)
    }
    
    func setColor(_ color : UIColor) {
        self.button.neumorphicLayer?.elementBackgroundColor = color.cgColor
    }
    
    func getView() -> EMTNeumorphicButton {
        button.addTarget(self, action: #selector(tapped(_:)), for: .touchUpInside)
        button.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 30, height: 30, enableInsets: true)
        return self.button
    }
    
    func setOnOrOff(type: SensibilityType) {
        button.isSelected = (type == self.type)
    }
    
    @objc func tapped(_ button: EMTNeumorphicButton) {
        self.delegate?.onTapped(type: self.type)
    }
}
