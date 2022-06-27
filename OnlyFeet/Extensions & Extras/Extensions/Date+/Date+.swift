//
//  Date+.swift
//  OnlyFeet
//
//  Created by Fuad on 27/06/2022.
//

import Foundation

extension Date {
    func returnDateOfBirthAsString() -> String {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "dd/MM/YY"
        
        return dateFormatter.string(from: self)
    }
}
