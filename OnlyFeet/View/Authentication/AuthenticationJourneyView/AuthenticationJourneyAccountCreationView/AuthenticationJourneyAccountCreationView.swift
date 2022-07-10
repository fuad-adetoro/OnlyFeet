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
    
    @StateObject var viewModel = AuthenticationViewModel(feetishAuthentication: FeetishAuthentication.shared)
    @EnvironmentObject var journeyViewModel: AuthenticationJourneyViewModel
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                if let image = profileImage {
                    AuthenticationJourneyPulsatingImageView(image: .constant(image))
                }
            }
            .onAppear {
                // Create Account
                viewModel.uploadAuthData(["displayName": displayName, "birthData": 0, "gender": 1])
                
                if let profileImage = profileImage {
                    viewModel.uploadProfilePhoto(profileImage)
                }
            }
            .onChange(of: viewModel.isAuthDataUploadComplete) { isComplete in
                if isComplete {
                    journeyViewModel.nextJourney()
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

struct AuthenticationJourneyAccountCreationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationJourneyAccountCreationView(displayName: .constant("Fuad Adetoro"), birthDate: .constant(Date()), gender: .constant(.male), profileImage: .constant(nil))
    }
}
