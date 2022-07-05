//
//  AuthenticationJourneyViewModel.swift
//  OnlyFeet
//
//  Created by Fuad on 24/06/2022.
//

import Combine
import AVFoundation
import SwiftUI

protocol AuthenticationJourneyBased {
    func nextJourney()
    func previousJourney()
    func makeView(displayName: Binding<String>, birthDate: Binding<Date>, gender: Binding<FeetishGender>, isImagePickerDisplayed: Binding<Bool>, profileImage: Binding<UIImage?>, croppedImage: Binding<UIImage?>) -> AnyView
    func getCurrentDateClosedRange() -> ClosedRange<Date>
}

public final class AuthenticationJourneyViewModel: ObservableObject {
    struct AuthDisplayAlert {
        var title: String?
        var message: String?
    }
    
    @Published var authenticationJourney: AuthenticationJourneyPosition = .init()
    var previousAuthenticationJourney: AuthenticationJourneyPosition?
    
    @Published var isDisplayingAlert = false
    var authDisplayAlert: AuthDisplayAlert?
}

extension AuthenticationJourneyViewModel: AuthenticationJourneyBased {
    func nextJourney() {
        self.previousAuthenticationJourney = self.authenticationJourney
        self.authenticationJourney = self.authenticationJourney.nextPosition()
    }
    
    func previousJourney() {
        if let previousJourney = self.authenticationJourney.previousPosition() {
            self.previousAuthenticationJourney = self.authenticationJourney
            self.authenticationJourney = previousJourney
        }
    }
}

extension AuthenticationJourneyViewModel {
    func makeView(displayName: Binding<String>, birthDate: Binding<Date>, gender: Binding<FeetishGender>, isImagePickerDisplayed: Binding<Bool>, profileImage: Binding<UIImage?>, croppedImage: Binding<UIImage?>) -> AnyView {
        switch authenticationJourney {
        case .rules:
            return AnyView(AuthenticationJourneyRulesView.init())
        case .name:
            return AnyView(AuthenticationJourneyNameView.init(displayName: displayName))
        case .birthday:
            return AnyView(AuthenticationJourneyDateOfBirthSelectionView.init(birthDate: birthDate))
        case .gender:
            return AnyView(AuthenticationJourneyGenderSelectionView.init(gender: gender))
        case .profilePhoto:
            return AnyView(AuthenticationJourneyProfilePhotoUploaderView.init(isImagePickerDisplayed: isImagePickerDisplayed, profileImage: profileImage, croppedImage: croppedImage))
        case .accountCreation:
            return AnyView(HomeAuthenticationView.init())
        case .notification:
            return AnyView(HomeAuthenticationView.init())
        case .getStarted:
            return AnyView(HomeAuthenticationView.init())
        case .complete:
            return AnyView(HomeAuthenticationView.init())
        }
    }
}

extension AuthenticationJourneyViewModel {
    func getCurrentDateClosedRange() -> ClosedRange<Date> {
        let min = Calendar.current.date(byAdding: .day, value: -41000, to: Date())!
        let max = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        return min...max
    }
}

extension AuthenticationJourneyViewModel {
    func determinePresentStyle() -> Edge {
        if let previousAuthJourney = self.previousAuthenticationJourney {
            let presentFromLeft = previousAuthJourney.rawValue < authenticationJourney.rawValue
            
            if presentFromLeft {
                return .trailing
            } else {
                return .leading
            }
        } else {
            return .leading
        }
    }
}
