//
//  AudioKindButtons.swift
//  NegotoRecorder
//
//  Created by kitaharamugirou on 2020/07/01.
//  Copyright © 2020 kitaharamugirou. All rights reserved.
//

import Foundation
import UIKit

protocol AudioKindButtonsDelegate: class {
    func onTapped(type: AudioKind)
}

class AudioKindButtons: NSObject {
    weak var delegate : AudioKindButtonsDelegate? = nil
    private var stack : UIStackView = UIStackView()
    private var buttons : [AudioKindButton]
    
    private lazy var descriptionLabel : UILabel = {
        let view = UILabel()
        view.text = ""
        view.textColor = MyColors.red
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
        
        let negoto = AudioKindButton(type: .negoto)
        let monooto = AudioKindButton(type: .monooto)
        buttons = [monooto,negoto]
        
        super.init()
        
        for button in buttons {
            button.setColor(color)
            stack.addArrangedSubview(button.getView())
            button.delegate = self
        }
        
        stack.setCustomSpacing(20, after: monooto.getView())
        
        self.baseView.addSubview(descriptionLabel)
        self.baseView.addSubview(stack)
        
        onTapped(type: .negoto)
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
    
    func setWeAreRecognizingAudios(count:Int) {
        if(count == 0) {
            descriptionLabel.text = ""
        } else{
            descriptionLabel.text = String(format: "weAreRecognizingAudios".localized, String(count))
        }
    }
}

extension AudioKindButtons: AudioKindButtonDelegate {
    func onTapped(type: AudioKind) {
        for button in self.buttons {
            button.setOnOrOff(type: type)
        }
        self.delegate?.onTapped(type: type)
    }
}
