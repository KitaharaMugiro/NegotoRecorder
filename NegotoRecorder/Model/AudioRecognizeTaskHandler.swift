//
//  AudioRecognizeTaskHandler.swift
//  NegotoRecorder
//
//  Created by kitaharamugirou on 2020/06/23.
//  Copyright © 2020 kitaharamugirou. All rights reserved.
//

import Foundation
class AudioRecognizeTaskHandler {
    var audioRecognizer : AudioRecognizer? = nil
    
    func processAudioRecognition() {
        print("processAudioRecognition")
        /**
        構成は「未検討のintervalを探しに行く => あれば処理を開始する
        なければ終了
         呼び出しもとは起動時 & 録音完了時
         */
        guard let interval = seeIfAudioIsRecognized() else {return}
        print("startTime = \(interval.startTime)")
        let audioRecognizer = AudioRecognizer(delegate: self)
        self.audioRecognizer = audioRecognizer
        audioRecognizer.recognize(interval: interval)
    }
    
    func seeIfAudioIsRecognized() -> ActivatedIntervalViewModel? {
        let repository = AudioRecordRepository()
        let intervals = repository.getNotRecognizedIntervals()
        if intervals.count == 0 {
            print("no more unrecognized sound")
            return nil
        } else {
            return intervals[0]
        }
    }
}

extension AudioRecognizeTaskHandler: AudioRecognizerDelegate {
    func skipRecognition() {
        print("skipRecognition")
        self.processAudioRecognition()
    }
    
    func onFailRequestAuth() {
        print("onFailRequestAuth")
    }
    
    func onFailRecognition(interval: ActivatedIntervalViewModel?) {
        print("onFailRecognition")
        guard let _interval = interval else {return}
        
        let repository = AudioRecordRepository()
        repository.updateIntervalTitle(interval: _interval)
        self.processAudioRecognition()
    }
    
    func onSuccessRecognition(text: String, interval: ActivatedIntervalViewModel?) {
        print("onSuccessRecognition")
        guard var _interval = interval else {return}
        _interval.title = text
        let repository = AudioRecordRepository()
        repository.updateIntervalTitle(interval: _interval)
        self.processAudioRecognition()
    }
}
