//
//  BackgroundUtils.swift
//  NegotoRecorder
//
//  Created by kitaharamugirou on 2020/06/23.
//  Copyright © 2020 kitaharamugirou. All rights reserved.
//

import Foundation
class BackgroundUtils {
    static func doGlobalJob(function:@escaping () -> ())
    {
        DispatchQueue.global().async(execute: {
            function()
        })

    }
}
