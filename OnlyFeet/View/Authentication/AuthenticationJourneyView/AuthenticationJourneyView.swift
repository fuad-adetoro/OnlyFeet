//
//  AuthenticationJourneyView.swift
//  OnlyFeet
//
//  Created by Fuad on 26/06/2022.
//

import SwiftUI

struct AuthenticationJourneyView: View {
    @ObservedObject var viewModel = AuthenticationJourneyViewModel()
    @ObservedObject var bannerViewModel = FeetishBannerViewModel()
    
    // user properties
    @State private var displayName = ""
    @State private var birthDate: Date = .init()
    @State private var gender: FeetishGender = .none
    @State private var croppedImage: UIImage? // the actual profile image!
    
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var isImagePickerDisplayed = false
    @State private var profileImage: UIImage?
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack {
                    AuthenticationJourneyDecisionButtonView.init()
                        .environmentObject(viewModel)
                        .frame(width: geometry.size.width, height: 50)
                    
                    viewModel.makeView(displayName: $displayName, birthDate: $birthDate, gender: $gender, isImagePickerDisplayed: $isImagePickerDisplayed, profileImage: $profileImage, croppedImage: $croppedImage)
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
            .sheet(isPresented: self.$isImagePickerDisplayed) {
                ImagePickerView(selectedImage: self.$profileImage, sourceType: self.sourceType)
            }
        }
    }
}

struct AuthenticationJourneyView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationJourneyView()
    }
}
