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
        return button
    }()
    
    private var audioRecorder = AudioRecorder()
    private var watcher :RecordInputLevelWatcher? = nil
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(button.getView())
        self.view.addSubview(titleView.getView())
        self.audioRecorder.setDelegate(delegate: self, audioDelegate: self)
        button.setRecorder(audioRecorder)
        
        let watcher = RecordInputLevelWatcher(recorder: audioRecorder)
        self.watcher = watcher
    }
    
    override func viewDidLayoutSubviews() {
        let width = self.view.frame.width
        button.setLayoutCenter(center:self.view.center, color: view.backgroundColor!.cgColor)
        titleView.setLayoutUpperCenter(width: width)
    }
}


extension RecordViewController : AudioRecorderDelegate, AVAudioRecorderDelegate {
    func onStartRecord() {
        print("start recording")
        self.watcher?.startWatch()
    }
    
    func onFailRecord() {
        print("fail recording")
    }
    
    func onFinishRecord() {
        print("finish recording")
        let repository = AudioRecordRepository()
        let fileName = audioRecorder.getFileName()
        guard let records = watcher?.exportRecord() else {return}
        repository.setAudioRecord(fileName: fileName, records: records)
        print("saved records")
    }
}
