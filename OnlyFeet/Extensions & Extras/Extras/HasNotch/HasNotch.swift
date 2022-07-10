//
//  HasNotch.swift
//  OnlyFeet
//
//  Created by Fuad on 09/07/2022.
//

import UIKit.UIApplication

// MARK: Has Notch
// MARK: - Checking if the device has a top or bottom notch basically asking is the device frameless like an Iphone X

var hasTopNotch: Bool {
    if #available(iOS 11.0, tvOS 11.0, *) {
        return UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0 > 20
    }
    return false
}

var hasBottomNotch: Bool {
    if #available(iOS 11.0, tvOS 11.0, *) {
        return UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0 > 20
    }
    return false
}
