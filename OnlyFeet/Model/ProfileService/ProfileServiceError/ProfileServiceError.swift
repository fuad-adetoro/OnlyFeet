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
    case notSignedIn
    case unknownError
    case usernameExists
    case couldNotUpdate
    case invalidUsername
    case networkError
}

extension ProfileServiceError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .maxWaitTimeReachedError:
            return "Took too long, please try again."
        case .errorSigningOut:
            return "Something went wrong! Please try again."
        case .notSignedIn:
            return "You aren't signed in!"
        case .unknownError:
            return "Please try again..."
        case .usernameExists:
            return "That username is taken."
        case .couldNotUpdate:
            return "We couldn't save your changes."
        case .invalidUsername:
            return "Username invalid."
        case .networkError:
            return "No network connection."
        }
    }
}
