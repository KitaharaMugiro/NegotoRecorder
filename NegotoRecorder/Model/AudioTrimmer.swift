//
//  AudioTrimmer.swift
//  NegotoRecorder
//
//  Created by kitaharamugirou on 2020/06/22.
//  Copyright © 2020 kitaharamugirou. All rights reserved.
//

import Foundation
import AVFoundation

class AudioTrimmer {
    func trimAudio(asset: AVAsset, startTime: Double, stopTime: Double, finished:@escaping (URL) -> ())
    {

            let compatiblePresets = AVAssetExportSession.exportPresets(compatibleWith:asset)

            if compatiblePresets.contains(AVAssetExportPresetMediumQuality) {

            guard let exportSession = AVAssetExportSession(asset: asset,
            presetName: AVAssetExportPresetAppleM4A) else{return}

            // Creating new output File url and removing it if already exists.
            let fileName = "trimmedAudio.m4a"
            let furl = CommonUtils.getFileURL(fileName: fileName)
            CommonUtils.removeFileIfExists(fileName: fileName) 

            exportSession.outputURL = furl
            exportSession.outputFileType = AVFileType.m4a

            let start: CMTime = CMTimeMakeWithSeconds(startTime, preferredTimescale: asset.duration.timescale)
            let stop: CMTime = CMTimeMakeWithSeconds(stopTime, preferredTimescale: asset.duration.timescale)
            let range: CMTimeRange = CMTimeRangeFromTimeToTime(start: start, end: stop)
            exportSession.timeRange = range

            exportSession.exportAsynchronously(completionHandler: {

                switch exportSession.status {
                case .failed:
                    print("Export failed: \(exportSession.error!.localizedDescription)")
                case .cancelled:
                    print("Export canceled")
                default:
                    print("Successfully trimmed audio")
                    DispatchQueue.main.async(execute: {
                        finished(furl)
                    })
                }
            })
        }
    }
}
