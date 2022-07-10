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
    case accountUsernameIsCreated = "FeetishAccountUsernameIsCreated"
}

protocol FeetishUserJourneyBased {
    func initialSignInOccured(doesNeedJourney: Bool, doesAccountHaveUsername: Bool)
    func accountJourneyComplete()
    func accountUsernameCreated()
    func signOutOccured()
    func checkIfUserIsSignedIn() -> Bool
    func checkIfAccountJourneyIsNeeded() -> Bool
    func checkIfAccountHasUsername() -> Bool
}

public final class FeetishUserJourney {
    static let shared = FeetishUserJourney()
    
    let userDefaults = UserDefaults.standard
}

extension FeetishUserJourney: FeetishUserJourneyBased {
    func initialSignInOccured(doesNeedJourney: Bool, doesAccountHaveUsername: Bool) {
        userDefaults.set(true, forKey: LoginJourneyUserDefaultKeys.loggedIn.rawValue)
        
        userDefaults.set(doesNeedJourney, forKey: LoginJourneyUserDefaultKeys.accountNeedsJourney.rawValue)
        
        userDefaults.set(doesAccountHaveUsername, forKey: LoginJourneyUserDefaultKeys.accountUsernameIsCreated.rawValue)
    }
    
    func accountJourneyComplete() {
        userDefaults.set(false, forKey: LoginJourneyUserDefaultKeys.accountNeedsJourney.rawValue)
    }
    
    func accountUsernameCreated() {
        userDefaults.set(true, forKey: LoginJourneyUserDefaultKeys.accountUsernameIsCreated.rawValue)
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
    
    func checkIfAccountHasUsername() -> Bool {
        if let doesAccountNeedJourney = userDefaults.value(forKey: LoginJourneyUserDefaultKeys.accountUsernameIsCreated.rawValue) as? Bool {
            return doesAccountNeedJourney
        } else {
            return false
        }
    }
}
