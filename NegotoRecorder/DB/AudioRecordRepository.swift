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
    @objc dynamic var title : String = ""
    @objc dynamic var isRecognized: Bool = false
    @objc dynamic var createdAt = Date()
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

    

class AudioRecordRealm: Object {
    @objc dynamic var id = ""
    @objc dynamic var fileName = ""
    @objc dynamic var createdAt = Date()
    var intervals = List<ActivatedIntervalRealm>()
}

class AudioRecordRepository {
    
    func getOriginalFilename(interval: ActivatedIntervalViewModel) -> String? {
        let realm = try! Realm()
        let record = realm.objects(AudioRecordRealm.self).filter("id == %@", interval.audioRecordId).first
        return record?.fileName
    }
    
    func deleteInterval(id: String) {
        let realm = try! Realm()
        let intervalRealm = realm.objects(ActivatedIntervalRealm.self).filter("id == %@", id)
        try! realm.write {
            realm.delete(intervalRealm)
        }
    }
    
    func updateIntervalTitle(interval:ActivatedIntervalViewModel) {
        let realm = try! Realm()
        let intervalRealm = realm.objects(ActivatedIntervalRealm.self).filter("id == %@", interval.id).first
        print("is it true? = \(intervalRealm?.id) == \(interval.id) (\(intervalRealm!.id == interval.id)")
        try! realm.write {
            intervalRealm!.title = interval.title
            intervalRealm!.isRecognized = true
            print("updated")
            print(intervalRealm)
        }
    }
    
    func getAllAudioRecords() -> [AudioRecordViewModel] {
        let realm = try! Realm()
        let records = realm.objects(AudioRecordRealm.self)
        return records.compactMap({ result in
            return AudioRecordViewModel(realmModel: result)
            })
    }
    
    
    func getAllIntervals() -> [ActivatedIntervalViewModel] {
        let files = self.getAllAudioRecords()
        var result:[ActivatedIntervalViewModel] = []
        for file in files {
            result += file.intervals
        }
        return result
    }
    
    func getAllAvailableIntervals(suffix:Int) -> [ActivatedIntervalViewModel] {
        let files = self.getAllAudioRecords()
        var result:[ActivatedIntervalViewModel] = []
        for file in files {
            let intervals = file.intervals
            result += intervals.filter{interval in
                return interval.isRecognized && interval.title != ""
            }
        }
        return result.suffix(suffix)
    }
    
    func getNotRecognizedIntervals() -> [ActivatedIntervalViewModel] {
        let realm = try! Realm()
        let records = realm.objects(AudioRecordRealm.self)
        var result:[ActivatedIntervalViewModel] = []
        for record in records {
            for interval in record.intervals {
                if !interval.isRecognized {
                    result.append(ActivatedIntervalViewModel(realmModel: interval))
                }
            }
        }
        return result
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
        print("recordsToRealmObjects")
        let list = List<ActivatedIntervalRealm>()
        for record in records {
            if  let endTime = record.endTime {
                print("set audioRecordId = \(id)")
                let elem = ActivatedIntervalRealm()
                elem.id = record.id
                elem.audioRecordId = id
                elem.filename = record.id + Constants.audioPrefix
                elem.startTime = record.startTime
                elem.endTime = endTime
                elem.title = ""
                elem.isRecognized = false
                elem.createdAt = record.createdAt
                list.append(elem)
            }
        }
        return list
    }
    
}
