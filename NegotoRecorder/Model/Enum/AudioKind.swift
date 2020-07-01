//
//  AudioKind.swift
//  NegotoRecorder
//
//  Created by kitaharamugirou on 2020/07/01.
//  Copyright © 2020 kitaharamugirou. All rights reserved.
//

import Foundation
enum AudioKind {
    case monooto
    case negoto
    
    func getText() -> String {
        switch self {
        case .monooto:
            return "monooto".localized
        case .negoto :
            return "negoto".localized

        }
    }
}
