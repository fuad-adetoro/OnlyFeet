//
//  AuthenticationJourneyView.swift
//  OnlyFeet
//
//  Created by Fuad on 26/06/2022.
//

import SwiftUI

struct AuthenticationJourneyView: View {
    @StateObject var viewModel = AuthenticationJourneyViewModel()
    @StateObject var bannerViewModel = FeetishBannerViewModel()
    
    // user properties
    @State private var displayName = ""
    @State private var username = ""
    @State private var birthDate: Date = .init()
    @State private var gender: FeetishGender = .none
    @State private var croppedImage: UIImage? // the actual profile image!
    
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var isImagePickerDisplayed = false
    @State private var profileImage: UIImage?
    
    @State private var didSkipProfileImage = false
    
    @Environment(\.viewController) private var viewControllerHolder: UIViewController?
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack {
                    if viewModel.authenticationJourney != .accountCreation {
                        AuthenticationJourneyDecisionButtonView(didSkipProfilePhoto: $didSkipProfileImage)
                            .environmentObject(viewModel)
                            .frame(width: geometry.size.width, height: 50)
                            .padding(.top, 15)
                    }
                    
                    if let view = viewModel.makeView(displayName: $displayName, username: $username, birthDate: $birthDate, gender: $gender, isImagePickerDisplayed: $isImagePickerDisplayed, profileImage: $profileImage, croppedImage: $croppedImage, didSkipProfileImage: $didSkipProfileImage) {
                        view
                            .environmentObject(viewModel)
                    } else {
                        FeetishLaunchScreenView()
                    }
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
            .sheet(isPresented: self.$isImagePickerDisplayed) {
                ImagePickerView(selectedImage: self.$profileImage, sourceType: self.sourceType)
            }
            .onChange(of: viewModel.authenticationJourney, perform: { authenticationJourney in
                if authenticationJourney == .profilePhoto {
                    self.didSkipProfileImage = false
                }
            })
        }
    }
}

struct AuthenticationJourneyView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationJourneyView()
    }
}
