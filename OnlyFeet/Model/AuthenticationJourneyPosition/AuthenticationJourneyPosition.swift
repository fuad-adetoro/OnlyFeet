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
    case username = 3
    case birthday = 4
    case gender = 5
    case profilePhoto = 6
    case accountCreation = 7
    case complete = 8
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
            let isUsernameCreated = FeetishUserJourney.shared.checkIfAccountHasUsername()
            
            if isUsernameCreated {
                return .birthday
            } else {
                return .username
            }
        } else if case .username = self {
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
        } else if case .username = self {
            return .name
        } else if case .birthday = self {
            let isUsernameCreated = FeetishUserJourney.shared.checkIfAccountHasUsername()
            
            if isUsernameCreated {
                return .name
            } else {
                return .username
            } 
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
