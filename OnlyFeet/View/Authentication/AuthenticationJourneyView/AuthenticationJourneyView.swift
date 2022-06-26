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
                Spacer()
                
                HStack {
                    Spacer()
                    Text("Authentication Journey View")
                    Spacer()
                }
                .onAppear {
                    
                }
                
                Spacer()
            }
        }
        .background(Image("AuthBG")
            .resizable()
            .scaledToFill()
            .edgesIgnoringSafeArea(.all)
        )
        .preferredColorScheme(.dark)
    }
}

struct AuthenticationJourneyView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationJourneyView()
    }
}
