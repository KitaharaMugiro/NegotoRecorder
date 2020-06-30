//
//  AudioRecognizer.swift
//  NegotoRecorder
//
//  Created by kitaharamugirou on 2020/06/23.
//  Copyright © 2020 kitaharamugirou. All rights reserved.
//

import Foundation
import Speech

protocol AudioRecognizerDelegate {
    func onFailRequestAuth()
    func onFailRecognition(interval: ActivatedIntervalViewModel?)
    func onSuccessRecognition(text: String, interval: ActivatedIntervalViewModel?) //かなりイケてないIF
    func skipRecognition()
}

class AudioRecognizer:NSObject {
    private let recognizer : SFSpeechRecognizer
    private let delegate: AudioRecognizerDelegate
    fileprivate var interval: ActivatedIntervalViewModel? = nil
    
    init(locale: Locale = Locale.init(identifier:"ja_JP"), delegate: AudioRecognizerDelegate) {
        self.recognizer = SFSpeechRecognizer(locale: locale)!
        self.delegate = delegate
    }
    
    func requestAuth() {
        SFSpeechRecognizer.requestAuthorization{ (authStatus) in
            DispatchQueue.main.async {
                
                if authStatus != .authorized {
                    self.delegate.onFailRequestAuth()
                    return
                }
                
                if !self.recognizer.isAvailable {
                    self.delegate.onFailRequestAuth()
                    return
                }
                
            }
        }
    }
    
    func recognize(interval : ActivatedIntervalViewModel) {
        let url = CommonUtils.getFileURL(fileName: interval.filename)
        self.requestRecoginization(url: url, interval:interval)
    }
    
    func requestRecoginization(url: URL, interval:ActivatedIntervalViewModel? = nil) {
        self.interval = interval
        let request = SFSpeechURLRecognitionRequest(url: url)
        print("start recognition now")
        recognizer.recognitionTask(with: request, delegate: self)
    }
}

extension AudioRecognizer: SFSpeechRecognitionTaskDelegate {
    func speechRecognitionTask(_ task: SFSpeechRecognitionTask, didFinishRecognition recognitionResult: SFSpeechRecognitionResult) {
        print("finish last result")
        self.delegate.onSuccessRecognition(text: recognitionResult.bestTranscription.formattedString, interval: self.interval)
    }
    
    func speechRecognitionTaskWasCancelled(_ task: SFSpeechRecognitionTask) {
        print("cancelled by user?")
        self.delegate.skipRecognition()
    }
    
    func speechRecognitionTask(_ task: SFSpeechRecognitionTask, didFinishSuccessfully successfully: Bool){
        print("finish recognition successfully = \(successfully)")
        if !successfully {
            if let _error = task.error as? AVError {
                if _error.code.rawValue == -11829 {
                    print("Cannot Open!")
                    self.delegate.skipRecognition()
                    return
                } else if _error.code.rawValue == 202 {
                    print("Rate Limits!!")
                    self.delegate.skipRecognition()
                    return
                } else {
                    print("Other error")
                    print(_error)
                    print(_error.code.rawValue)
                }
            }
            self.delegate.onFailRecognition(interval:interval)
            return
        }
    }
}
