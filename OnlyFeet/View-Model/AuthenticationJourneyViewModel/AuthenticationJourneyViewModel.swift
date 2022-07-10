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
    func makeView(displayName: Binding<String>, username: Binding<String>, birthDate: Binding<Date>, gender: Binding<FeetishGender>, isImagePickerDisplayed: Binding<Bool>, profileImage: Binding<UIImage?>, croppedImage: Binding<UIImage?>, didSkipProfileImage: Binding<Bool>) -> AnyView?
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
    func makeView(displayName: Binding<String>, username: Binding<String>, birthDate: Binding<Date>, gender: Binding<FeetishGender>, isImagePickerDisplayed: Binding<Bool>, profileImage: Binding<UIImage?>, croppedImage: Binding<UIImage?>, didSkipProfileImage: Binding<Bool>) -> AnyView? {
        if case .rules = authenticationJourney {
            return AnyView(AuthenticationJourneyRulesView.init())
        } else if case .name = authenticationJourney {
            return AnyView(AuthenticationJourneyNameView.init(displayName: displayName))
        } else if case .username = authenticationJourney {
            return AnyView(AuthenticationJourneyUsernameView.init(username: username))
        } else if case .birthday = authenticationJourney {
            return AnyView(AuthenticationJourneyDateOfBirthSelectionView.init(birthDate: birthDate))
        } else if case .gender = authenticationJourney {
            return AnyView(AuthenticationJourneyGenderSelectionView.init(gender: gender))
        } else if case .profilePhoto = authenticationJourney {
            return AnyView(AuthenticationJourneyProfilePhotoUploaderView.init(isImagePickerDisplayed: isImagePickerDisplayed, profileImage: profileImage, croppedImage: croppedImage))
        } else if case .accountCreation = authenticationJourney {
            return AnyView(AuthenticationJourneyAccountCreationView.init(displayName: displayName, birthDate: birthDate, gender: gender, profileImage: croppedImage, didSkipProfileImage: didSkipProfileImage))
        } else {
            return nil
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
