//
//  AppTitleLabel.swift
//  NegotoRecorder
//
//  Created by kitaharamugirou on 2020/06/19.
//  Copyright © 2020 kitaharamugirou. All rights reserved.
//

import Foundation
import UIKit
class AppTitleLabel {
    var label : UILabel
    init() {
        let view = UILabel()
        view.text = "AI寝言レコーダー"
        view.textColor = MyColors.gray
        view.textAlignment = .center
        view.font = UIFont.systemFont(ofSize: 30)
        self.label = view
    }
    
    func getView() -> UILabel {
        return label
    }
    
    func setLayoutUpperCenter(width: CGFloat) {
        label.frame = CGRect(x: 30, y: 200, width: width - 60, height: 50)
    }
}
