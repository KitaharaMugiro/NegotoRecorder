//
//  SensibilityType.swift
//  NegotoRecorder
//
//  Created by kitaharamugirou on 2020/06/29.
//  Copyright © 2020 kitaharamugirou. All rights reserved.
//

import Foundation
enum SensibilityType {
    case small
    case medium
    case large
    
    func getDecibelValue() -> Float {
        switch self {
        case .small:
            return 130
        case .medium :
            return 110
        case .large :
            return 90
        }
    }
    
    func getText() -> String {
        switch self {
        case .small:
            return "S"
        case .medium :
            return "M"
        case .large :
            return "L"
        }
    }
}
