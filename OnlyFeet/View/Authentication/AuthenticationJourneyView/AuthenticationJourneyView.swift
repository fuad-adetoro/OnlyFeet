//
//  AuthenticationJourneyView.swift
//  OnlyFeet
//
//  Created by Fuad on 26/06/2022.
//

import SwiftUI

struct AuthenticationJourneyView: View {
    @ObservedObject var viewModel = AuthenticationJourneyViewModel.shared
    @ObservedObject var bannerViewModel = FeetishBannerViewModel.shared
    
    var body: some View {
        ZStack {
            VStack {
                Text("Authentication Journey View")
            }
        }
    }
}

struct AuthenticationJourneyView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationJourneyView()
    }
}
