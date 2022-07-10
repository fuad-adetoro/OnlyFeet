//
//  AuthenticationJourneyPosition.swift
//  OnlyFeet
//
//  Created by Fuad on 24/06/2022.
//

import Foundation

public enum AuthenticationJourneyPosition: Int, CaseIterable {
    case rules = 1
    case name = 2
    case birthday = 3
    case gender = 4
    case profilePhoto = 5
    case accountCreation = 6
    case complete = 7
}

extension AuthenticationJourneyPosition {
    init() {
        self.init(rawValue: 1)!
        // begin Journey!
    }
    
    func nextPosition() -> Self {
        if case .rules = self {
            return .name
        } else if case .name = self {
            return .birthday
        } else if case .birthday = self {
            return .gender
        } else if case .gender = self {
            return .profilePhoto
        } else if case .profilePhoto = self {
            return .accountCreation
        } else {
            return .complete
        }
    }
    
    func previousPosition() -> Self? {
        if case .rules = self {
            return nil
        } else if case .name = self {
            return .rules
        } else if case .birthday = self {
            return .name
        } else if case .gender = self {
            return .birthday
        } else if case .profilePhoto = self {
            return .gender
        } else if case .accountCreation = self {
            return .profilePhoto
        }
        
        return nil
    }
}
