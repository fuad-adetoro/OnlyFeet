//
//  BiometricType.swift
//  OnlyFeet
//
//  Created by Fuad on 27/06/2022.
//

import LocalAuthentication

class FeetishBiometrics {
    static let shared = FeetishBiometrics.init()
    
    func biometricType() -> BiometricType {
        let authContext = LAContext()
        if #available(iOS 11, *) {
            let _ = authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
            switch(authContext.biometryType) {
            case .none:
                return .none
            case .touchID:
                return .touch
            case .faceID:
                return .face
            @unknown default:
                return .none
            }
        } else {
            return authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) ? .touch : .none
        }
    }
    
    func isIphoneWithFaceDetection() -> Bool {
        let authContext = LAContext()
        if #available(iOS 11, *) {
            let _ = authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
            switch(authContext.biometryType) {
            case .faceID:
                //print("FACE!")
                return true
            default:
                return false
            }
        } else {
            return false
        }
    }
}

enum BiometricType {
    case none
    case touch
    case face
}
