//
//  AIRecordUsecase.swift
//  NegotoRecorder
//
//  Created by kitaharamugirou on 2020/07/14.
//  Copyright © 2020 kitaharamugirou. All rights reserved.
//

//録音 + 音量監視 + 音声認識(TaskHandler) を一挙にやるUsecase
import Foundation
import AVFoundation
import UIKit

class AIRecordUsecase {
    private var audioRecorder = AudioRecorder()
    private var watcher :RecordInputLevelWatcher? = nil
    private var audioRecognizer : AudioRecognizer? = nil
    private var timer : Timer? = nil
    
    func startRotation() {
        self.startRecord()
        
        //timer setup
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(withTimeInterval: 3000, repeats: true) { _ in
            self.refreshRecord()
        }
    }
    
    func endRotation() {
        self.timer?.invalidate()
        self.timer = nil
        self.endRecord()
    }
    
    private func startRecord() {
        let randomFilename = UUID().uuidString + ".m4a"
        self.audioRecorder.prepareRecord(fileName: randomFilename)
        self.audioRecorder.startRecord()
        self.watcher?.startWatch()
    }
    
    //一旦終了させて再開させる。音声認識は裏で回す
    private func refreshRecord() {
        self.endRecord()
        self.startRecord()
    }
    
    private func startSave() {
        let fileName = audioRecorder.getFileName()
        guard let records = watcher?.exportRecord() else {return}
        let repository = AudioRecordRepository()
        repository.setAudioRecord(fileName: fileName, records: records)
        print("saved records")
    }
    
    private func endRecord() {
        //watcherとrecorderを止める
        self.watcher?.endWatch()
        self.audioRecorder.stopRecord()
        
        //save始める
        self.startSave()
        
        //音声認識始める
        let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.startProcessAudioRecognition()
    }
    
    func requestAuth() {
        self.audioRecognizer?.requestAuth()
    }
    
    func initializeDependency(delegate:AudioRecorderDelegate, audioDelegate:AVAudioRecorderDelegate, watcherDelegate : RecordInputLevelWatcherDelegate, recogDelegate: AudioRecognizerDelegate? = nil) {
        //recorder setup
        self.audioRecorder.setDelegate(delegate: delegate, audioDelegate: audioDelegate)
        
        //watcher setup
        self.watcher?.endWatch()
        let watcher = RecordInputLevelWatcher(recorder: audioRecorder)
        watcher.delegate = watcherDelegate
        self.watcher = watcher
        
        // recognizer setup(for request auth)
        let locale = NSLocale.current
        self.audioRecognizer = AudioRecognizer(locale: locale, delegate: self)
    }
    
    func setSensibility(value : SensibilityType) {
        self.watcher?.setThreshhold(value: value.getDecibelValue())
    }
}


extension AIRecordUsecase :AudioRecognizerDelegate {
    func onFailRequestAuth() {
        print("onFailRequestAuth")
    }
    
    func onFailRecognition(interval: ActivatedIntervalViewModel?) {
    }
    
    func onSuccessRecognition(text: String, interval: ActivatedIntervalViewModel?) {
    }
    
    func skipRecognition() {
    }
}
