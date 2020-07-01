//
//  AudioKindButton.swift
//  NegotoRecorder
//
//  Created by kitaharamugirou on 2020/07/01.
//  Copyright © 2020 kitaharamugirou. All rights reserved.
//

import Foundation
import UIKit
import EMTNeumorphicView

protocol AudioKindButtonDelegate: class {
    func onTapped(type: AudioKind)
}

class AudioKindButton:NSObject  {
    var button : EMTNeumorphicButton
    var type : AudioKind
    weak var delegate :AudioKindButtonDelegate? = nil

    init(type : AudioKind) {
        let button = EMTNeumorphicButton(type: .custom)
        button.neumorphicLayer?.cornerRadius = 12
        button.neumorphicLayer?.elementDepth = 7
        self.button = button
        self.type = type
        super.init()
        self.setText(type: type)
    }
    
    private func setText(type : AudioKind) {
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
    
    func setOnOrOff(type: AudioKind) {
        button.isSelected = (type == self.type)
    }
    
    @objc func tapped(_ button: EMTNeumorphicButton) {
        self.delegate?.onTapped(type: self.type)
    }
}
