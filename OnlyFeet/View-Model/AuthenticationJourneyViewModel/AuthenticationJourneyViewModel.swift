//
//  AuthenticationJourneyViewModel.swift
//  OnlyFeet
//
//  Created by Fuad on 24/06/2022.
//

import Combine
import AVFoundation

protocol AuthenticationJourneyBased {
    func nextJourney()
    func previousJourney()
}

public final class AuthenticationJourneyViewModel: ObservableObject, AuthenticationJourneyBased {
    static let shared = AuthenticationJourneyViewModel.init()
    
    var authenticationJourney: AuthenticationJourneyPosition = .init()
    
    func nextJourney() {
        self.authenticationJourney = self.authenticationJourney.nextPosition()
    }
    
    func previousJourney() {
        if let previousJourney = self.authenticationJourney.previousPosition() {
            self.authenticationJourney = previousJourney
        }
    }
}
