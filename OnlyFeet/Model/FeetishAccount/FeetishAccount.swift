//
//  FeetishAccount.swift
//  OnlyFeet
//
//  Created by Fuad on 22/06/2022.
//

import Foundation

public struct FeetishAccount {
    var profilePictureURL: String?
    var name: String?
    var biograph: String?
    var username: String?
    var userID: String?
    var email: String?
    var dateOfBirth: String?
    var dateCreated: Double?
    
    public init(dataDict: [String: Any?]) {
        if let profilePictureURL = dataDict["profilePictureURL"] as? String {
            self.profilePictureURL = profilePictureURL
        }
        
        if let email = dataDict["email"] as? String {
            self.email = email
        }
        
        if let name = dataDict["name"] as? String {
            self.name = name
        }
        
        if let biograph = dataDict["biograph"] as? String {
            self.biograph = biograph
        }
        
        if let username = dataDict["username"] as? String {
            self.username = username
        }
        
        if let userID = dataDict["userID"] as? String {
            self.userID = userID
        }
        
        if let dateOfBirth = dataDict["dateOfBirth"] as? String {
            self.dateOfBirth = dateOfBirth
        }
        
        if let dateCreated = dataDict["dateCreated"] as? Double {
            self.dateCreated = dateCreated
        }
    }
}
