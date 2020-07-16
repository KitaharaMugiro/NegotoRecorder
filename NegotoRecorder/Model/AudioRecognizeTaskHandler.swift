//
//  AudioRecognizeTaskHandler.swift
//  NegotoRecorder
//
//  Created by kitaharamugirou on 2020/06/23.
//  Copyright © 2020 kitaharamugirou. All rights reserved.
//

import Foundation
class AudioRecognizeTaskHandler {
    lazy var audioRecognizer : AudioRecognizer = {
        let locale = NSLocale.current
        let audioRecognizer = AudioRecognizer(locale: locale, delegate: self)
        return audioRecognizer
    }()
    
    func processAudioRecognition() {
        print("processAudioRecognition")
        /**
        構成は「未検討のintervalを探しに行く => あれば処理を開始する
        なければ終了
         呼び出しもとは起動時 & 録音完了時
         */
        guard let interval = seeIfAudioIsRecognized() else {return}
        guard let originalFilename = getOriginalFilename(interval) else {return}
        print("filename = \(interval.filename)")
        print("startTime = \(interval.startTime)")
        
        print("will trim audio files")
        let avAsset = CommonUtils.getAvAsset(fileName: originalFilename)
        let trimmer = AudioTrimmer()
        trimmer.trimAudio(asset: avAsset, startTime: interval.startTime, stopTime: interval.endTime, fileName: interval.id + Constants.audioPrefix, finished: {url in
            print("successfully trim and save \(url)")
            self.audioRecognizer.recognize(interval: interval)
        })
    }
    
    func getOriginalFilename(_ interval: ActivatedIntervalViewModel) -> String? {
        let repository = AudioRecordRepository()
        return repository.getOriginalFilename(interval: interval)
    }
    
    func seeIfAudioIsRecognized() -> ActivatedIntervalViewModel? {
        let repository = AudioRecordRepository()
        let intervals = repository.getNotRecognizedIntervals()
        if intervals.count == 0 {
            print("no more unrecognized sound")
            return nil
        } else {
            print("find unrecognized sound = \(intervals.count)")
            print(intervals[0])
            return intervals[0]
        }
    }
    
    func getNumberOfAudiosNotRecognizedYet() -> Int {
        let repository = AudioRecordRepository()
        let intervals = repository.getNotRecognizedIntervals()
        return intervals.count
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
        print("updated for nothing")
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
