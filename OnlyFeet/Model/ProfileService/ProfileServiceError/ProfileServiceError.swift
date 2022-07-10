//
//  ProfileServiceError.swift
//  OnlyFeet
//
//  Created by Fuad on 10/07/2022.
//

import Foundation

public enum ProfileServiceError: Error, Equatable {
    case errorSigningOut
    case maxWaitTimeReachedError
}

extension ProfileServiceError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .maxWaitTimeReachedError:
            return "Took too long, please try again."
        case .errorSigningOut:
            return "Something went wrong! Please try again." 
        }
    }
}
