//
//  SensibilityHorizontalButtons.swift
//  NegotoRecorder
//
//  Created by kitaharamugirou on 2020/06/28.
//  Copyright © 2020 kitaharamugirou. All rights reserved.
//

import Foundation
import UIKit

protocol SensibilityHorizontalButtonsDelegate: class {
    func onTapped(type: SensibilityType)
}

class SensibilityHorizontalButtons: NSObject {
    weak var delegate : SensibilityHorizontalButtonsDelegate? = nil
    private var stack : UIStackView = UIStackView()
    private var buttons : [SensibilityButton]
    private lazy var descriptionLabel : UILabel = {
        let view = UILabel()
        view.text = "changeSensibility".localized
        view.textColor = MyColors.gray
        view.textAlignment = .center
        return view
    }()
    private lazy var baseView: UIView = {
        let view = UIView()
        return view
    }()
    
    init(color : UIColor) {
        stack.alignment = .center
        stack.distribution = .fillEqually
        
        let s = SensibilityButton(type: .small)
        let m = SensibilityButton(type: .medium)
        let l = SensibilityButton(type: .large)
        buttons = [s,m,l]
        
        super.init()
        
        for button in buttons {
            button.setColor(color)
            stack.addArrangedSubview(button.getView())
            button.delegate = self
        }
        
        stack.setCustomSpacing(20, after: s.getView())
        stack.setCustomSpacing(20, after: m.getView())
        
        self.baseView.addSubview(descriptionLabel)
        self.baseView.addSubview(stack)
        
        //TODO: とりあえずMで(保存する)
        onTapped(type: .medium)
    }
    
    func getView() -> UIView {
        return self.baseView
    }
    
    func setLayoutUnder(view: UIView, width : CGFloat) {
        let margin : CGFloat = 20
        
        baseView.frame = CGRect(x: 0 , y: view.frame.maxY + 30, width: width, height: 50)
        descriptionLabel.frame = CGRect(x: 0, y: 0, width: width, height: 15)
        stack.frame = CGRect(x: margin , y: 25, width: width - 2*margin, height: 30)
    }
}

extension SensibilityHorizontalButtons: SensibilityButtonDelegate {
    func onTapped(type: SensibilityType) {
        for button in self.buttons {
            button.setOnOrOff(type: type)
        }
        self.delegate?.onTapped(type: type)
    }
}
