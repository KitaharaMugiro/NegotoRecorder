//
//  AudioFileCleaner.swift
//  NegotoRecorder
//
//  Created by kitaharamugirou on 2020/07/07.
//  Copyright © 2020 kitaharamugirou. All rights reserved.
//

import Foundation
//端末内にファイルがないのにデータとして残るとバグに繋がるので定期的にチェックして、ファイルがなければデータも消す
class AudioFileCleaner {
    
    func startClean() {
        let intervals = self.getAllActivatedIntervals()
        for interval in intervals {
            if !self.checkExistFile(fileName: interval.filename) {
                self.deleteDataFromDB(fileId: interval.id)
            }
        }
    }
    
    private func getAllActivatedIntervals() -> [ActivatedIntervalViewModel] {
        let repository = AudioRecordRepository()
        return repository.getAllIntervals()
    }
    
    private func checkExistFile(fileName: String) -> Bool {
        return CommonUtils.isFileExist(fileName: fileName)
    }
    
    private func deleteDataFromDB(fileId: String) {
        let repository = AudioRecordRepository()
        repository.deleteInterval(id: fileId)
    }
}
