//
//  AudioPlayer.swift
//  NegotoRecorder
//
//  Created by kitaharamugirou on 2020/06/21.
//  Copyright © 2020 kitaharamugirou. All rights reserved.
//

import Foundation
import AVFoundation
protocol AudioPlayerDelegate:class  {
    func onFailPlay()
}

class AudioPlayer {
    var recordingSession: AVAudioSession!
    var audioPlayer:AVAudioPlayer!
    
    weak var delegate : AudioPlayerDelegate?
    weak var audioDelegate : AVAudioPlayerDelegate?
    
    private var timer : Timer? = nil
    
    private var END_TIME: Double? = nil
    private var START_TIME : Double = 0
    
    func setDelegate(delegate: AudioPlayerDelegate , audioDelegate: AVAudioPlayerDelegate) {
        self.delegate = delegate
        self.audioDelegate = audioDelegate
    }
    
    func preparePlay(fileName:String = "recording.m4a", START_TIME:Double = 0, END_TIME:Double? = nil) {
        self.END_TIME = END_TIME
        self.START_TIME = START_TIME
        
        var error: NSError?
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: CommonUtils.getFileURL(fileName: fileName) as URL)
        } catch let error1 as NSError {
            error = error1
            audioPlayer = nil
        }
        
        if let err = error {
            print("AVAudioPlayer error: \(err.localizedDescription)")
            self.delegate?.onFailPlay()
        } else {
            audioPlayer.delegate = self.audioDelegate
            audioPlayer.prepareToPlay()
            audioPlayer.currentTime = START_TIME
            audioPlayer.volume = 10.0
        }
    }
    
    func play() {
        self.audioPlayer.play()
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.checkTime()
        }
    }
    
    private func checkTime() {
        guard let endTime = END_TIME else {return}
        if self.audioPlayer.currentTime > endTime {
            self.audioPlayer.currentTime = START_TIME
            self.pause()
        }
    }
    
    func pause() {
        self.audioPlayer.pause()
    }
    
    func description() {
        print("START_TIME:\(self.START_TIME), END_TIME:\(self.END_TIME)")
    }
}
