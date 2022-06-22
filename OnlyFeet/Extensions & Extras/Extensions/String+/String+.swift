//
//  String+.swift
//  OnlyFeet
//
//  Created by Fuad on 22/06/2022.
//

import Foundation

extension String {
    func isValidEmail() -> Bool {
        let email = self
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}
