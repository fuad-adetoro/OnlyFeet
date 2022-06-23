//
//  String+.swift
//  OnlyFeet
//
//  Created by Fuad on 22/06/2022.
//

import Foundation

public extension String {
    public func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
    
    public func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
}
