//
//  OFCameraPosition.swift
//  OnlyFeet
//
//  Created by Fuad on 08/07/2022.
//

import Foundation

enum OFCameraPosition {
    case front
    case back
}

extension OFCameraPosition {
    func change() -> Self {
        if self == .front {
            return .back
        } else {
            return .front
        }
    }
}
