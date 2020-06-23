//
//  RecordInputLevelWatcher.swift
//  NegotoRecorder
//
//  Created by kitaharamugirou on 2020/06/21.
//  Copyright © 2020 kitaharamugirou. All rights reserved.
//

import Foundation

//recordのinput levelを1秒ごとに監視する
//threshholdを超えたら記録を開始する
//threshholdを下回ったらそこで記録を終了する
//開始時間と終了時間をペアで持っておく

struct AudioActivatedInterval {
    var startTime: Double
    var endTime : Double? = nil
    var id : String = UUID().uuidString
}

class RecordInputLevelWatcher {
    private let watchInterval:TimeInterval = 1
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
        self.timer = Timer.scheduledTimer(withTimeInterval: watchInterval, repeats: true) { t in
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
        let startTime = max(self.recorder.getCurrentTime() - watchInterval, 0)
        self.audioActivatedInterval = AudioActivatedInterval(startTime:  startTime)
    }
    
    private func deactivateRecord() {
        print("deactivate record")
        self.isRecording = false
        guard var interval = self.audioActivatedInterval else {return}
        interval.endTime = self.recorder.getCurrentTime() + watchInterval
        self.audioActivatedIntervalRecord.append(interval)
        self.audioActivatedInterval = nil
    }
    
    func exportRecord() -> [AudioActivatedInterval] {
        return self.audioActivatedIntervalRecord.filter({interval in
            guard let endTime = interval.endTime else {return false}
            return endTime > interval.startTime
        })
    }
}
