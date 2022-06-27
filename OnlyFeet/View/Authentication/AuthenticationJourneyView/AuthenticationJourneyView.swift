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
    
    // user properties
    @State private var displayName = ""
    @State private var birthDate: Date = .init()
    @State private var gender: FeetishGender = .none
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack {
                    AuthenticationJourneyDecisionButtonView.init()
                        .environmentObject(viewModel)
                        .frame(width: geometry.size.width, height: 50)
                    
                    viewModel.makeView(displayName: $displayName, birthDate: $birthDate, gender: $gender)
                        .environmentObject(viewModel)
                }
                
                if viewModel.isDisplayingAlert {
                    AuthenticationJourneyDateOfBirthAlertView.init(date: $birthDate, isDisplayingAlert: $viewModel.isDisplayingAlert)
                        .environmentObject(viewModel)
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
}

struct AuthenticationJourneyView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationJourneyView()
    }
}
