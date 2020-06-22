//
//  PlayButton.swift
//  NegotoRecorder
//
//  Created by kitaharamugirou on 2020/06/21.
//  Copyright © 2020 kitaharamugirou. All rights reserved.
//

import Foundation
import UIKit
import EMTNeumorphicView
class PlayButton  {
    var button : EMTNeumorphicButton
    var player : AudioPlayer?
    
    init() {
        let button = EMTNeumorphicButton(type: .custom)
         let offIcon = UIImage(systemName:  "play")?.withTintColor(MyColors.gray, renderingMode: .alwaysOriginal)
         let onIcon = UIImage(systemName:  "pause")?.withTintColor(MyColors.gray, renderingMode: .alwaysOriginal)
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
    
    func setRightBottom(view:UIView , color : CGColor) {
        view.addSubview(self.getView())
        button.anchor(top: nil, left: nil, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 20, paddingRight: 20, width: 50, height: 50, enableInsets: false)
        button.neumorphicLayer?.elementBackgroundColor = color
        button.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    
    @objc func tapped(_ button: EMTNeumorphicButton) {
        button.isSelected = !button.isSelected
        if button.isSelected {
            print("button is tapped and selected")
            print(self.player)
            self.player?.description()
            player?.play()
            let value:CGFloat = 10
            button.imageEdgeInsets = UIEdgeInsets(top: value, left: value, bottom: value, right: value+5)
        } else {
            player?.pause()
            let value:CGFloat  = 5
            button.imageEdgeInsets = UIEdgeInsets(top: value, left: value, bottom: value, right: value)
        }
    }
    
    func setPlayer(_ player: AudioPlayer) {
        print("setPlayer from PlayButton")
        self.player = player
        print(self.player)
    }
}
