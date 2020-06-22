//
//  HeaderLabel.swift
//  NegotoRecorder
//
//  Created by kitaharamugirou on 2020/06/21.
//  Copyright © 2020 kitaharamugirou. All rights reserved.
//

import Foundation
import UIKit
class HeaderLabel {
    var label : UILabel
    init() {
        let view = UILabel()
        view.text = "過去の寝言を振り返る"
        view.textColor = MyColors.gray
        view.textAlignment = .center
        view.font = UIFont.systemFont(ofSize: 30)
        self.label = view
    }
    
    func getView() -> UILabel {
        return label
    }
    
    func setLayoutTopCenter(width: CGFloat) {
        label.frame = CGRect(x: 30, y: 50, width: width - 60, height: 50)
    }
}
