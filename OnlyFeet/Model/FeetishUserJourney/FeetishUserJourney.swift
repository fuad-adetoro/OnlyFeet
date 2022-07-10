//
//  FeetishUserJourney.swift
//  OnlyFeet
//
//  Created by Fuad on 10/07/2022.
//

import Foundation

public enum LoginJourneyUserDefaultKeys: String {
    case loggedIn = "FeetishLoggedIn"
    case accountNeedsJourney = "FeetishAccountRegistrationJourney"
}

protocol FeetishUserJourneyBased {
    func initialSignInOccured(doesNeedJourney: Bool)
    func accountJourneyComplete()
    func signOutOccured()
    func checkIfUserIsSignedIn() -> Bool
    func checkIfAccountJourneyIsNeeded() -> Bool
}

public final class FeetishUserJourney {
    static let shared = FeetishUserJourney()
    
    let userDefaults = UserDefaults.standard
}

extension FeetishUserJourney: FeetishUserJourneyBased {
    func initialSignInOccured(doesNeedJourney: Bool) {
        userDefaults.set(true, forKey: LoginJourneyUserDefaultKeys.loggedIn.rawValue)
        
        if doesNeedJourney {
            userDefaults.set(true, forKey: LoginJourneyUserDefaultKeys.accountNeedsJourney.rawValue)
        }
    }
    
    func accountJourneyComplete() {
        userDefaults.set(false, forKey: LoginJourneyUserDefaultKeys.accountNeedsJourney.rawValue)
    }
    
    func signOutOccured() {
        userDefaults.set(false, forKey: LoginJourneyUserDefaultKeys.loggedIn.rawValue)
    }
    
    func checkIfUserIsSignedIn() -> Bool {
        if let isLoggedIn = userDefaults.value(forKey: LoginJourneyUserDefaultKeys.loggedIn.rawValue) as? Bool {
            return isLoggedIn
        } else {
            return false
        }
    }
    
    func checkIfAccountJourneyIsNeeded() -> Bool {
        if let doesAccountNeedJourney = userDefaults.value(forKey: LoginJourneyUserDefaultKeys.accountNeedsJourney.rawValue) as? Bool {
            return doesAccountNeedJourney
        } else {
            return false
        } 
    }
}
