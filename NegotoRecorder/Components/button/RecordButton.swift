//
//  RecordButton.swift
//  NegotoRecorder
//
//  Created by kitaharamugirou on 2020/06/19.
//  Copyright © 2020 kitaharamugirou. All rights reserved.
//

import Foundation
import UIKit
import EMTNeumorphicView
class RecordButton  {
    var button : EMTNeumorphicButton
    weak var recorder : AudioRecorder?
    
    init() {
        let button = EMTNeumorphicButton(type: .custom)
         let offIcon = UIImage(systemName:  "power")?.withTintColor(MyColors.gray, renderingMode: .alwaysOriginal)
         let onIcon = UIImage(systemName:  "power")?.withTintColor(MyColors.red, renderingMode: .alwaysOriginal)
         button.setImage(offIcon, for: .normal)
         button.setImage(onIcon, for: .selected)
         button.contentVerticalAlignment = .fill
         button.contentHorizontalAlignment = .fill
         button.neumorphicLayer?.cornerRadius = 24
         button.neumorphicLayer?.elementDepth = 7
         self.button = button
    }
    
    func getView() -> EMTNeumorphicButton {
        button.addTarget(self, action: #selector(tapped(_:)), for: .touchUpInside)
        return self.button
    }
    
    func setLayoutCenter(center: CGPoint , color : CGColor) {
        button.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
        button.center = center
        button.neumorphicLayer?.elementBackgroundColor = color
        button.imageEdgeInsets = UIEdgeInsets(top: 26, left: 24, bottom: 22, right: 24)
    }
    
    @objc func tapped(_ button: EMTNeumorphicButton) {
        button.isSelected = !button.isSelected
        if button.isSelected {
            recorder?.startRecord()
            button.imageEdgeInsets = UIEdgeInsets(top: 30, left: 26, bottom: 25, right: 26)
        } else {
            recorder?.stopRecord()
            button.imageEdgeInsets = UIEdgeInsets(top: 26, left: 24, bottom: 22, right: 24)
        }
    }
    
    func setRecorder(_ recorder: AudioRecorder) {
        recorder.prepareRecord(fileName: "recording.m4a")
        self.recorder = recorder
    }
}
