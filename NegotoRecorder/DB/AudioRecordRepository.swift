//
//  RecordRepository.swift
//  NegotoRecorder
//
//  Created by kitaharamugirou on 2020/06/21.
//  Copyright © 2020 kitaharamugirou. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

// Define your models like regular Swift classes
class ActivatedIntervalRealm: Object {
    @objc dynamic var id = ""
    @objc dynamic var audioRecordId = "" //結合用
    @objc dynamic var filename = ""
    @objc dynamic var startTime:Double = 0
    @objc dynamic var endTime:Double = 0
    @objc dynamic var createdAt = Date()
}
    

class AudioRecordRealm: Object {
    @objc dynamic var id = ""
    @objc dynamic var fileName = ""
    @objc dynamic var createdAt = Date()
    var intervals = List<ActivatedIntervalRealm>()
}

class AudioRecordRepository {
    
    func getAllAudioRecords() -> [AudioRecordViewModel] {
        let realm = try! Realm()
        let records = realm.objects(AudioRecordRealm.self)
        print("records = " + records.count.description)
        return records.compactMap({ result in
            return AudioRecordViewModel(realmModel: result)
        })
    }
    
    func setAudioRecord(fileName:String, records: [AudioActivatedInterval]) {
        print(records.count.description + "のレコードが保存されました。")
        for record in records {
            print(record.startTime.description + " - " + record.endTime!.description)
        }
        
        let audioRecordRealm = AudioRecordRealm()
        let uuid = UUID().uuidString
        audioRecordRealm.id = uuid
        audioRecordRealm.fileName = fileName
        audioRecordRealm.createdAt = Date()
        audioRecordRealm.intervals = self.recordsToRealmObjects(records:records, id:uuid)
        autoreleasepool {
            let realm = try! Realm()
            try! realm.write {
                realm.add(audioRecordRealm)
            }
        }
    }
    
    private func recordsToRealmObjects(records: [AudioActivatedInterval], id:String) -> List<ActivatedIntervalRealm> {
        let list = List<ActivatedIntervalRealm>()
        for record in records {
            if  let endTime = record.endTime {
                let elem = ActivatedIntervalRealm()
                elem.id = UUID().uuidString
                elem.audioRecordId = id
                elem.filename = ""
                elem.startTime = record.startTime
                elem.endTime = endTime
                elem.createdAt = Date()
                list.append(elem)
            }
        }
        return list
    }
    
}
