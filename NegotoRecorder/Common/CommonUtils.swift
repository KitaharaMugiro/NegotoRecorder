//
//  CommonUtils.swift
//  NegotoRecorder
//
//  Created by kitaharamugirou on 2020/06/21.
//  Copyright © 2020 kitaharamugirou. All rights reserved.
//

import Foundation
import AVFoundation
class CommonUtils {
    static func getAvAsset(fileName : String) -> AVAsset {
        let path = self.getFileURL(fileName: fileName)
        return AVAsset(url: path)
    }
    
    static func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    static func removeFileIfExists(fileName:String) {
        let path = getDocumentsDirectory().appendingPathComponent(fileName)
        do {
            try FileManager.default.removeItem(at: path)
        } catch let error as NSError {
            print("File Delete: \(error.domain)")
        }
    }
    
    static func getFileURL(fileName:String) -> URL {
        let path = getDocumentsDirectory().appendingPathComponent(fileName)
        return path as URL
    }
    
    static func isFileExist(fileName: String) -> Bool {
        let path = getDocumentsDirectory().appendingPathComponent(fileName)
        return FileManager.default.fileExists(atPath: path.path)
    }
    
    static func dateFromString(string: String, format: String) -> Date {
        let formatter: DateFormatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = format
        return formatter.date(from: string)!
    }
    
    static func stringFromDate(date: Date, format: String) -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
    static func stringFromDateLocalized(date: Date) -> String {
        let formatter = DateFormatter()
        let locale = NSLocale.current
        let format = DateFormatter.dateFormat(fromTemplate: "yyyyMMdd hhmm", options: 0, locale: locale)
        formatter.dateFormat = format
        let dateString = formatter.string(from: date)
        return dateString
    }
}
