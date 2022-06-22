//
//  FeetishAuthError.swift
//  OnlyFeet
//
//  Created by Fuad on 22/06/2022.
//

import Foundation

public enum FeetishAuthError: Error, Equatable {
    case signInError(errorMessage: String)
    case signOutError(errorMessage: String)
    case resetPasswordError(errorMessage: String)
    case usernameExistsError(errorMessage: String)
    case accountDoesNotExistError
    case accountDataDoesNotExistError
    case accountCreationFailureError(errorMessage: String)
    case accountCreationInitialDataUploadError(errorMessage: String)
    case unknownError
    
    case maxWaitTimeReachedError
    
    case emailInvalidError
    case passwordDoesNotMatchError
    case passwordToShortError
    
    case networkError
}

extension FeetishAuthError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .signOutError(let errorMsg):
            return "\(errorMsg)"
        case .resetPasswordError(let errorMsg):
            return "\(errorMsg)"
        case .usernameExistsError(let errorMsg):
            return "\(errorMsg)"
        case .signInError(let errorMsg):
            return "\(errorMsg)"
        case .accountCreationFailureError(let errorMsg):
            return "\(errorMsg)"
        case .accountCreationInitialDataUploadError(let errorMsg):
            return "\(errorMsg)"
        case .emailInvalidError:
            return "Email is not valid."
        case .passwordToShortError:
            return "Your password is too short."
        case .passwordDoesNotMatchError:
            return "Your passwords do not match."
        case .networkError:
            return "Check your network and try again."
        default:
            return "Unknown Error"
        }
    }
}
