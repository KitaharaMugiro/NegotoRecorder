//
//  StatisticView.swift
//  NegotoRecorder
//
//  Created by kitaharamugirou on 2020/06/24.
//  Copyright © 2020 kitaharamugirou. All rights reserved.
//

import Foundation
import UIKit
class StatisticView {
    var label : UILabel
    
    init() {
        let view = UILabel()
        view.text = ""
        view.numberOfLines = 2
        view.textColor = MyColors.gray
        view.textAlignment = .left
        view.font = UIFont.systemFont(ofSize: 18)
        self.label = view
    }
    
    func setText(monooto:Int, negoto:Int) {
        self.label.text = String(format: NSLocalizedString("statisticText", comment: ""), String(monooto), String(negoto))
    }
    
    func getView() -> UILabel {
        return label
    }
    
    func setLayoutUnder(view: UIView) {
        label.frame = CGRect(x: view.frame.minX, y: view.frame.maxY + 10, width: view.frame.width, height: 70)
        label.sizeToFit()
    }

}
