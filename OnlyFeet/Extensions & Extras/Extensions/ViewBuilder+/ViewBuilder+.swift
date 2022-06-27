//
//  ViewBuilder+.swift
//  OnlyFeet
//
//  Created by Fuad on 26/06/2022.
//

import SwiftUI

extension View {
    @ViewBuilder func currentJourneyView<Content: View>(_ journey: AuthenticationJourneyPosition, content: (Self) -> Content) -> some View {
        switch journey {
        default:
            HomeAuthenticationView()
        } 
    }
}
