//
//  StateMessage.swift
//  NegotoRecorder
//
//  Created by kitaharamugirou on 2020/06/28.
//  Copyright © 2020 kitaharamugirou. All rights reserved.
//

import Foundation
import UIKit

class StateMessage {
    var label : UILabel
    var state:RecordState = .noop {
        didSet {
            print(state)
            switch state {
            case .recording:
                self.setRecording()
            case .listening :
                self.setListening()
            case .noop:
                self.setEmpty()
            case .error:
                self.setError()
            }
            label.sizeToFit()
        }
    }
    
    init() {
        let view = UILabel()
        view.text = "clickBelowButtonAndRecord".localized
        view.textColor = MyColors.gray
        view.textAlignment = .center
        view.font = UIFont.systemFont(ofSize: 18)
        self.label = view
    }
    
    private func setListening() {
        self.label.text = "Listening..."
        self.label.textColor = MyColors.gray
    }
    
    private func setError() {
        self.label.text = "Error"
        self.label.textColor = MyColors.red
    }
    
    private func setRecording() {
        self.label.text = "Recording..."
        self.label.textColor = MyColors.red
    }
    
    private func setEmpty() {
        self.label.text = "clickBelowButtonAndRecord".localized
        self.label.textColor = MyColors.gray
    }

    func getView() -> UILabel {
        return label
    }
    
    func setLayoutUpper(view: UIView, parent: UIView) {
        label.frame = CGRect(x: 0, y: view.frame.minY - 40, width: parent.frame.width, height: 70)
        label.sizeToFit()
        label.frame.size.width = parent.frame.width
    }
}
