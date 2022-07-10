//
//  OFCameraPurpose.swift
//  OnlyFeet
//
//  Created by Fuad on 08/07/2022.
//

import Foundation

enum OFCameraPurpose {
    case profilePhotoFromAuth
    case none
}

extension OFCameraPurpose {
    func purposeTitle() -> String {
        switch self {
        case .profilePhotoFromAuth:
            return "Profile Photo"
        default:
            return ""
        }
    }
}
