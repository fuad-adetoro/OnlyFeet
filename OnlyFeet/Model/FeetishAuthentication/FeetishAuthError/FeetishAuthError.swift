//
//  FeetishAuthError.swift
//  OnlyFeet
//
//  Created by Fuad on 22/06/2022.
//

import Foundation

public enum FeetishAuthError: Error {
    case signInError(errorMessage: String)
    case signOutError(errorMessage: String)
    case resetPasswordError(errorMessage: String)
    case usernameExistsError(errorMessage: String)
    case accountDoesNotExistError
    case accountDataDoesNotExistError
    case accountCreationFailureError(errorMessage: String)
    case accountCreationInitialDataUploadError(errorMessage: String)
    case unknownError
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
        default:
            return "\(self.localizedDescription)"
        }
    }
}
