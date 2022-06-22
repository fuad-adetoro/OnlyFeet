//
//  getCurrentInterval.swift
//  OnlyFeet
//
//  Created by Fuad on 22/06/2022.
//

import Foundation

// MARK: - GetCurrentTimeInterval
func getCurrentTimeInterval() -> TimeInterval {
    let now = Date()
    
    // Unic Epoch Time Interval
    return now.timeIntervalSinceReferenceDate
}
