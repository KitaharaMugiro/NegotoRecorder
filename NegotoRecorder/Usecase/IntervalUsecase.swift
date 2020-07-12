//
//  IntervalUsecase.swift
//  NegotoRecorder
//
//  Created by kitaharamugirou on 2020/07/12.
//  Copyright © 2020 kitaharamugirou. All rights reserved.
//

import Foundation
class IntervalUsecase {
    func deleteInteval(id : String) {
        let repository = AudioRecordRepository()
        repository.deleteInterval(id: id)
    }
}
