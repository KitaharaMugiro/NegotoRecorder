//
//  IntervalUsecase.swift
//  NegotoRecorder
//
//  Created by kitaharamugirou on 2020/07/12.
//  Copyright © 2020 kitaharamugirou. All rights reserved.
//

import Foundation
class IntervalUsecase {
    let audioRep = AudioRecordRepository()
    let filterRep = FilteringRepository()
    
    func addFilteringWord(title : String) {
        filterRep.addFiltering(title: title)
    }
    
    func deleteInteval(id : String) {
        audioRep.deleteInterval(id: id)
    }
    
    func getNegotoIntervals() -> [ActivatedIntervalViewModel] {
        let words = filterRep.getFilteringWords()
        let negotos =  audioRep.getAllAvailableIntervals(suffix:999999).sorted(by: {a,b in
            return a.createdAt > b.createdAt
        })
        let filteredNegotos = negotos.filter{ n in
            return !words.contains(n.title)
        }
        return filteredNegotos
    }

    func getMonootoIntervals() -> [ActivatedIntervalViewModel] {
        let allIntervals = audioRep.getAllIntervals()
        let monooto =  allIntervals.filter {a in
            return a.title == ""
        }.sorted(by: {a,b in
            return a.createdAt > b.createdAt
        })
        return monooto
    }
}
