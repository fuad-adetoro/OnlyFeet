//
//  FeetishLaunchScreenView.swift
//  OnlyFeet
//
//  Created by Fuad on 10/07/2022.
//

import SwiftUI

struct FeetishLaunchScreenView: View {
    @State private var isLoggedIn = false
    @State private var doesNeedJourney = false
    @State private var shouldDisplayLogin = false
    
    @Environment(\.viewController) private var viewControllerHolder: UIViewController?
    
    var body: some View {
        ZStack {
            if !isLoggedIn && !doesNeedJourney && !shouldDisplayLogin {
                Image("LaunchScreen")
                    .ignoresSafeArea()
                    .onAppear {
                        let doesAccountNeedJourney = FeetishUserJourney.shared.checkIfAccountJourneyIsNeeded()
                        
                        let isLoggedIn = FeetishUserJourney.shared.checkIfUserIsSignedIn()
                        
                        if isLoggedIn {
                            if doesAccountNeedJourney {
                                self.doesNeedJourney = true
                            } else {
                                self.isLoggedIn = true
                            }
                        } else {
                            self.shouldDisplayLogin = true
                        }
                    }
            }
            
            if isLoggedIn {
                OFTabView(doesHaveTopNotch: .constant(hasTopNotch))
                    .ignoresSafeArea()
            } else if doesNeedJourney {
                AuthenticationJourneyView()
                    .ignoresSafeArea()
            } else if shouldDisplayLogin {
                HomeAuthenticationView()
                    .ignoresSafeArea()
            }
        } 
    }
}

struct FeetishLaunchScreenView_Previews: PreviewProvider {
    static var previews: some View {
        FeetishLaunchScreenView()
    }
}
