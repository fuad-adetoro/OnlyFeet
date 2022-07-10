//
//  AuthenticationJourneyUsernameView.swift
//  OnlyFeet
//
//  Created by Fuad on 10/07/2022.
//

import SwiftUI

struct AuthenticationJourneyUsernameView: View {
    @EnvironmentObject var viewModel: AuthenticationJourneyViewModel
    @Binding var username: String
    
    @StateObject var profileViewModel = ProfileViewModel()
    
    @StateObject private var bannerViewModel = FeetishBannerViewModel()
    
    var body: some View {
            ZStack {
                VStack {
                    HStack {
                        Spacer().frame(width: 50)
                        
                        Text("Create a username")
                            .foregroundColor(.white)
                            .font(.largeTitle)
                        
                        Spacer()
                    }
                    
                    Spacer().frame(height: 40)
                    
                    HStack {
                        Spacer().frame(width: 50)
                        
                        TextFieldWithColoredPlaceholder.init(text: $username, placeholderText: .constant("Username..."), placeholderColor: .constant(Color("CustomLightGray").opacity(0.4)), canDismissKeyboard: .constant(false))
                        
                        Spacer()
                    }
                    
                    HStack {
                        Spacer().frame(width: 50)
                        Rectangle.init().frame(width: 195, height: 4)
                            .foregroundColor(.white)
                        Spacer()
                    }
                    
                    Spacer().frame(height: 40)
                    
                    HStack {
                        Spacer().frame(width: 20)
                        
                        AuthenticationJourneyContinueButtonView.init(isInactive: .constant($username.wrappedValue.isEmpty), username: $username)
                            .environmentObject(viewModel)
                            .environmentObject(profileViewModel)
                            .disabled(profileViewModel.isUsernameUpdating)
                        
                        Spacer().frame(width: 20)
                    }
                    
                    Spacer()
                }
                
                if profileViewModel.isUsernameUpdating {
                    AuthenticationUsernameProgressView()
                }
            }
            .modifier(FeetishBannerView(model: $bannerViewModel.model, isBeingDragged: $bannerViewModel.isBeingDragged))
            .onChange(of: profileViewModel.profileError, perform: { profileError in
                if let error = profileError {
                    self.bannerViewModel.loadNewBanner(bannerData: .init(title: "Error", message: error.errorDescription ?? "Something went wrong", bannerError: error))
                }
            })
            .onChange(of: profileViewModel.isUsernameUpdateComplete) { isUsernameUpdateComplete in
                if isUsernameUpdateComplete {
                    profileViewModel.isUsernameUpdateComplete = false
                    
                    viewModel.nextJourney()
                }
            }
        }
}

struct AuthenticationUsernameProgressView: View {
    var body: some View {
        VStack {
            Spacer()
            
            HStack {
                Spacer()
                
                ProgressView("Creating")
                    .foregroundColor(.white)
                    .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                
                Spacer()
            }
            
            Spacer()
        }
    }
}
