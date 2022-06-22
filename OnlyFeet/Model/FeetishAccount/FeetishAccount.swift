//
//  FeetishAccount.swift
//  OnlyFeet
//
//  Created by Fuad on 22/06/2022.
//

import Foundation

public struct FeetishAccount: Codable {
    var profilePictureURL: String?
    var name: String?
    var biograph: String?
    var username: String?
    var userID: String?
    var email: String?
    var dateOfBirth: String?
    
    public init(from decoder: Decoder) throws {
        let valuesInContainer = try decoder.container(keyedBy: CodingKeys.self)
        
        if let profilePictureURLRaw = try? valuesInContainer.decode(String.self, forKey: .profilePictureURL) {
            profilePictureURL = profilePictureURLRaw
        }
        
        if let nameRaw = try? valuesInContainer.decode(String.self, forKey: .name) {
            name = nameRaw
        }
        
        if let biographRaw = try? valuesInContainer.decode(String.self, forKey: .biograph) {
            biograph = biographRaw
        }
        
        if let usernameRaw = try? valuesInContainer.decode(String.self, forKey: .username) {
            username = usernameRaw
        }
        
        if let profilePictureURLRaw = try? valuesInContainer.decode(String.self, forKey: .profilePictureURL) {
            profilePictureURL = profilePictureURLRaw
        }
        
        if let userIDRaw = try? valuesInContainer.decode(String.self, forKey: .userID) {
            userID = userIDRaw
        }
        
        if let emailRaw = try? valuesInContainer.decode(String.self, forKey: .email) {
            email = emailRaw
        }
        
        if let dateOfBirthRaw = try? valuesInContainer.decode(String.self, forKey: .dateOfBirth) {
            dateOfBirth = dateOfBirthRaw
        }
    }
}
