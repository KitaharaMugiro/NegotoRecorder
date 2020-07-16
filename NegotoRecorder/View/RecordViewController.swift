//
//  RecordViewController.swift
//  NegotoRecorder
//
//  Created by kitaharamugirou on 2020/06/18.
//  Copyright © 2020 kitaharamugirou. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class RecordViewController: UIViewController {
    lazy var titleView : AppTitleLabel = {
        let view = AppTitleLabel()
        return view
    }()
    
    lazy var button : RecordButton = {
        let button = RecordButton()
        button.delegate = self
        return button
    }()
    
    lazy var infoButton : InfoButton = {
        let button = InfoButton()
        button.delegate = self
        return button
    }()
    
    lazy var stateMessage : StateMessage = {
        let message = StateMessage()
        return message
    }()
    
    lazy var sensibilityButtons : SensibilityHorizontalButtons = {
        let view = SensibilityHorizontalButtons(color: self.view.backgroundColor ?? MyColors.theme)
        view.delegate = self
        return view
    }()
    
    private let aiRecordUsecase : AIRecordUsecase = AIRecordUsecase()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(button.getView())
        self.view.addSubview(titleView.getView())
        self.view.addSubview(infoButton.getView())
        self.view.addSubview(stateMessage.getView())
        self.view.addSubview(sensibilityButtons.getView())
        
        self.aiRecordUsecase.initializeDependency(delegate: self, audioDelegate: self, watcherDelegate: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.aiRecordUsecase.requestAuth()
    }
    
    override func viewDidLayoutSubviews() {
        let width = self.view.frame.width
        button.setLayoutCenter(center:self.view.center, color: view.backgroundColor!.cgColor)
        titleView.setLayoutUpperCenter(width: width)
        infoButton.setRightCornerLayout(width: width)
        stateMessage.setLayoutUpper(view: button.getView(), parent:self.view)
        sensibilityButtons.setLayoutUnder(view: button.getView(), width: self.view.frame.width)
    }

}


extension RecordViewController : AudioRecorderDelegate, AVAudioRecorderDelegate {
    func onStartRecord() {
        print("start recording")
        self.stateMessage.state = .listening
    }
    
    func onFailRecord() {
        print("fail recording")
        self.stateMessage.state = .error
    }
    
    func onFinishRecord() {
        print("finish recording")
        self.stateMessage.state = .noop
    }
}

extension RecordViewController: RecordInputLevelWatcherDelegate {
    func onActivated() {
        self.stateMessage.state = .recording
    }
    
    func onDeactivated() {
        self.stateMessage.state = .listening
    }
}

extension RecordViewController: SensibilityHorizontalButtonsDelegate {
    func onTapped(type: SensibilityType) {
        self.aiRecordUsecase.setSensibility(value: type)
    }
}

extension RecordViewController: InfoButtonDelegate {
    func onTappedInfo() {
        self.present(TermsViewController(), animated: true, completion: nil)
    }
}

extension RecordViewController : RecordButtonDelegate {
    func onClickStartRecord() {
        self.aiRecordUsecase.startRotation()
    }
    
    func onClickEndRecord() {
        self.aiRecordUsecase.endRotation()
    }
}
