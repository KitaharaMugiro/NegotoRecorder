//
//  AudioRecorder.swift
//  NegotoRecorder
//
//  Created by kitaharamugirou on 2020/06/21.
//  Copyright © 2020 kitaharamugirou. All rights reserved.
//

import Foundation
import AVFoundation

protocol AudioRecorderDelegate:class {
    func onStartRecord()
    func onFailRecord()
    func onFinishRecord()
}

//setDelegate => prepareRecordを行った後に、startRecordで録音を開始する
class AudioRecorder {
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    weak var delegate : AudioRecorderDelegate?
    weak var audioDelegate : AVAudioRecorderDelegate?
    private var fileName : String = ""
    
    func setDelegate(delegate:AudioRecorderDelegate, audioDelegate:AVAudioRecorderDelegate) {
        self.delegate = delegate
        self.audioDelegate = audioDelegate
    }
    
    func prepareRecord(fileName:String = "recording.m4a") {
        self.fileName = fileName
        let audioFilename = CommonUtils.getDocumentsDirectory().appendingPathComponent(fileName)

        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.isMeteringEnabled = true
            audioRecorder.delegate = self.audioDelegate
        } catch {
            self.delegate?.onFailRecord()
        }
    }
    
    //もし録音開始とともにリクエストをするのが嫌だったら。
    func requestRecordPermission() {
        recordingSession = AVAudioSession.sharedInstance()
        recordingSession.requestRecordPermission() { _ in
            
        }
    }
    
    func startRecord() {
        recordingSession = AVAudioSession.sharedInstance()
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        self.audioRecorder.record()
                        self.delegate?.onStartRecord()
                    } else {
                        self.delegate?.onFailRecord()
                    }
                }
            }
        } catch {
            self.delegate?.onFailRecord()
        }
    }
    
    
    func stopRecord() {
        audioRecorder.stop()
        self.delegate?.onFinishRecord()
    }
    
    func getCurrentTime() -> Double {
        return self.audioRecorder.currentTime
    }
    
    func getMeterValue() -> Float {
        self.audioRecorder.updateMeters()
        return self.audioRecorder.averagePower(forChannel: 0) + 160 //0 - 160
    }
    
    func getFileName() -> String {
        return self.fileName
    }
}
