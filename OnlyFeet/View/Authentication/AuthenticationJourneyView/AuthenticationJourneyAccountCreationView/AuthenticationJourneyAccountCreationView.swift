//
//  AuthenticationJourneyAccountCreationView.swift
//  OnlyFeet
//
//  Created by Fuad on 08/07/2022.
//

import SwiftUI

struct AuthenticationJourneyAccountCreationView: View {
    @Binding var displayName: String
    @Binding var birthDate: Date
    @Binding var gender: FeetishGender
    @Binding var profileImage: UIImage?
    @Binding var didSkipProfileImage: Bool
    
    @StateObject var authenticationViewModel = AuthenticationViewModel(feetishAuthentication: FeetishAuthentication.shared)
    @EnvironmentObject var viewModel: AuthenticationJourneyViewModel
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                if didSkipProfileImage {
                    AuthenticationJourneyPulsatingCircularView()
                } else if let image = profileImage {
                    AuthenticationJourneyPulsatingImageView(image: .constant(image))
                }
            }
            .onAppear {
                // Create Account
                if let profileImage = profileImage {
                    authenticationViewModel.uploadProfilePhoto(profileImage)
                }
                
                authenticationViewModel.uploadAuthData(["displayName": displayName, "dateOfBirth": birthDate.returnDateOfBirthAsString(), "gender": gender.rawValue])
            }
            .onChange(of: authenticationViewModel.isAuthDataUploadComplete) { isComplete in
                if isComplete {
                    viewModel.nextJourney()
                }
            }
            .onChange(of: authenticationViewModel.feetishPhotoUploadError) { feetishPhotoUploadError in
                if let _ = feetishPhotoUploadError {
                    if viewModel.authenticationJourney == .accountCreation {
                        viewModel.previousJourney()
                    }
                }
            }
            .onChange(of: authenticationViewModel.didErrorOccur) { didErrorOccur in
                if didErrorOccur {
                    if viewModel.authenticationJourney == .accountCreation {
                        viewModel.previousJourney()
                    }
                }
            }
        }
    }
}

struct AuthenticationJourneyPulsatingImageView: View {
    @Binding var image: UIImage
    
    @State private var animationAmount: CGFloat = 1
    
    var body: some View {
        VStack {
            Spacer()
            
            HStack {
                Spacer()
                
                Image(uiImage: image)
                //Image(systemName: "heart.fill")
                    .resizable()
                    .frame(width: 140, height: 140)
                    .cornerRadius(10)
                    .overlay(RoundedRectangle(cornerRadius: 10)
                        .stroke(Color("LoginColor2"), lineWidth: 4))
                    .shadow(radius: 20)
                    .scaleEffect(animationAmount)
                    .animation(
                        .linear(duration: 0.5)
                        .delay(0.25)
                        .repeatForever(autoreverses: true),
                        value: animationAmount)
                    .onAppear {
                        animationAmount = 1.2
                    }
                
                Spacer()
            }
            Spacer()
        }
    }
}

struct AuthenticationJourneyPulsatingCircularView: View {
    @State private var animationAmount: CGFloat = 1
    
    var body: some View {
        VStack {
            Spacer()
            
            HStack {
                Spacer()
                
                Circle()
                    .fill(Color("LoginColor2"))
                    .frame(width: 140, height: 140)
                    .overlay(
                        Circle()
                            .stroke(Color.black, lineWidth: 4)
                    )
                    .shadow(radius: 20)
                    .scaleEffect(animationAmount)
                    .animation(
                        .linear(duration: 0.5)
                        .delay(0.25)
                        .repeatForever(autoreverses: true),
                        value: animationAmount)
                    .onAppear {
                        animationAmount = 1.2
                    }
                
                Spacer()
            }
            Spacer()
        }
    }
}
