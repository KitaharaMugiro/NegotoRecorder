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
    
    lazy var infoButton : InfoButton = {
        let button = InfoButton()
        return button
    }()
    
    private var audioRecorder = AudioRecorder()
    private var watcher :RecordInputLevelWatcher? = nil
    private var audioRecognizer : AudioRecognizer? = nil
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(button.getView())
        self.view.addSubview(titleView.getView())
        self.view.addSubview(infoButton.getView())
        
        //set up models
        self.audioRecorder.setDelegate(delegate: self, audioDelegate: self)
        button.setRecorder(audioRecorder)
        
        let watcher = RecordInputLevelWatcher(recorder: audioRecorder)
        self.watcher = watcher
        
        self.audioRecognizer = AudioRecognizer(delegate: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.audioRecognizer?.requestAuth()
    }
    
    override func viewDidLayoutSubviews() {
        let width = self.view.frame.width
        button.setLayoutCenter(center:self.view.center, color: view.backgroundColor!.cgColor)
        titleView.setLayoutUpperCenter(width: width)
        infoButton.setRightCornerLayout(width: width)
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
        let fileName = audioRecorder.getFileName()
        guard let records = watcher?.exportRecord() else {return}
        
        print("will trim audio files")
        let avAsset = CommonUtils.getAvAsset(fileName: fileName)
        let trimmer = AudioTrimmer()
        for record in records {
            guard let endTime = record.endTime else {continue}
            trimmer.trimAudio(asset: avAsset, startTime: record.startTime, stopTime: endTime, fileName: record.id + Constants.audioPrefix, finished: {url in
                print("successfully trim and save \(url)")
            })
        }
        
        print("will save records")
        let repository = AudioRecordRepository()
        repository.setAudioRecord(fileName: fileName, records: records)
        print("saved records")
        
        //この段階だとまだtrimされたファイルが存在しない
        let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.startProcessAudioRecognition()
    }
}

extension RecordViewController : AudioRecognizerDelegate {
    
    /** ここでは音声認識はしない */
    func onFailRecognition(interval: ActivatedIntervalViewModel?) {
    }
    
    func onSuccessRecognition(text: String, interval: ActivatedIntervalViewModel?) {
    }
    func skipRecognition() {
    }
    
    /** request authをする */
    func onFailRequestAuth() {
        print("onFailRequestAuth")
    }
}
