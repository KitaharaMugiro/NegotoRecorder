//
//  InfoButton.swift
//  NegotoRecorder
//
//  Created by kitaharamugirou on 2020/06/24.
//  Copyright © 2020 kitaharamugirou. All rights reserved.
//

import Foundation
import UIKit

class InfoButton:NSObject {
    var button : UIButton
    
    override init() {
        let button = UIButton()
        button.setImage(UIImage(systemName: "info.circle"), for: .normal)
        self.button = button
    }
    
    func getView() -> UIView {
        button.addTarget(self, action: #selector(tapped(_:)), for: .touchUpInside)
        return self.button
    }
    
    @objc func tapped(_ button: UIButton) {
        //open 利用規約
    }
    
    
    func setRightCornerLayout(width: CGFloat) {
        self.button.frame = CGRect(x: width - 40, y: 20, width: 30, height: 30)
    }
}
