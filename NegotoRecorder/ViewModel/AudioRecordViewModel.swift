//
//  AudioRecordViewModel.swift
//  NegotoRecorder
//
//  Created by kitaharamugirou on 2020/06/21.
//  Copyright © 2020 kitaharamugirou. All rights reserved.
//

import Foundation


struct ActivatedIntervalViewModel {
    var id:String
    var audioRecordId:String  //結合用
    var filename:String
    var startTime:Double
    var endTime:Double
    var title : String
    var isRecognized: Bool
    var createdAt:Date
    
    init(realmModel: ActivatedIntervalRealm) {
        self.id = realmModel.id
        self.audioRecordId = realmModel.audioRecordId
        self.filename = realmModel.filename
        self.startTime = realmModel.startTime
        self.endTime = realmModel.endTime
        self.createdAt = realmModel.createdAt
        self.title = realmModel.title
        self.isRecognized = realmModel.isRecognized
    }
}

struct AudioRecordViewModel {
    var id : String
    var fileName: String
    var intervals: [ActivatedIntervalViewModel]
    
    init(realmModel: AudioRecordRealm) {
        self.fileName = realmModel.fileName
        self.id = realmModel.id
        self.intervals = realmModel.intervals.compactMap({realmObject in
            return ActivatedIntervalViewModel(realmModel: realmObject)
        })
    }
}
