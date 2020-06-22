//
//  RecordInputLevelWatcher.swift
//  NegotoRecorder
//
//  Created by kitaharamugirou on 2020/06/21.
//  Copyright © 2020 kitaharamugirou. All rights reserved.
//

import Foundation

//recordのinput levelを0.1秒ごとに監視する
//threshholdを超えたら記録を開始する
//threshholdを下回ったらそこで記録を終了する
//開始時間と終了時間をペアで持っておく

struct AudioActivatedInterval {
    var startTime: Double
    var endTime : Double? = nil
}

class RecordInputLevelWatcher {
    private var threshhold:Float = 100 //db ここどうやって決めたらいいんだろう
    private var isRecording = false
    
    private var audioActivatedInterval: AudioActivatedInterval?
    private var audioActivatedIntervalRecord: [AudioActivatedInterval] = []
    
    private let recorder : AudioRecorder
    private var timer: Timer? = nil
    
    init(recorder: AudioRecorder) {
        self.recorder = recorder
    }
    
    func startWatch(){
        print("start watching")
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { t in
            let meterValue = self.recorder.getMeterValue()
            if meterValue > self.threshhold {
                if !self.isRecording {
                    self.activateRecord()
                }
            } else {
                if self.isRecording {
                    self.deactivateRecord()
                }
            }
        }
    }
    
    func endWatch() {
        self.timer?.invalidate()
        self.timer = nil
    }
    
    private func activateRecord() {
        print("activate record")
        self.isRecording = true
        self.audioActivatedInterval = AudioActivatedInterval(startTime: self.recorder.getCurrentTime() ?? -1)
    }
    
    private func deactivateRecord() {
        print("deactivate record")
        self.isRecording = false
        guard var interval = self.audioActivatedInterval else {return}
        interval.endTime = self.recorder.getCurrentTime() ?? -1
        self.audioActivatedIntervalRecord.append(interval)
        self.audioActivatedInterval = nil
    }
    
    func exportRecord() -> [AudioActivatedInterval] {
        if var interval = self.audioActivatedInterval {
            interval.endTime = self.recorder.getCurrentTime() ?? -1
            self.audioActivatedIntervalRecord.append(interval)
            self.audioActivatedInterval = nil
        }
        return self.audioActivatedIntervalRecord
    }
}
