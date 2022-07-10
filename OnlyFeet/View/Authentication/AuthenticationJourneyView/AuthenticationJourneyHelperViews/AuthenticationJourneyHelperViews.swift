//
//  AuthenticationJourneyHelperViews.swift
//  OnlyFeet
//
//  Created by Fuad on 27/06/2022.
//

import Foundation
import SwiftUI
import Introspect

struct AuthenticationContinueButtonWithBackground: View {
    @EnvironmentObject var viewModel: AuthenticationJourneyViewModel
    
    @Binding var isInActive: Bool
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer().frame(height: geometry.size.height - 70)
                
                VStack {
                    Spacer()
                    
                    HStack {
                        Spacer().frame(width: 20)
                        
                        AuthenticationJourneyContinueButtonView.init(isInactive: $isInActive, username: .constant(""))
                        .environmentObject(viewModel)
                        
                        Spacer().frame(width: 20)
                    }
                    .padding(.top, FeetishBiometrics.shared.isIphoneWithFaceDetection() ? 10 : 0)
                    
                    Spacer()
                }
                .frame(height: 80)
                .background(Color.black.opacity(0.5))
                    
            }
        }
    }
}

struct AuthenticationJourneyContinueButtonView: View {
    @Binding var isInactive: Bool
    
    @EnvironmentObject var viewModel: AuthenticationJourneyViewModel
    @EnvironmentObject var profileViewModel: ProfileViewModel
    
    @Binding var username: String
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Button {
                    //
                    if case .birthday = viewModel.authenticationJourney {
                        viewModel.isDisplayingAlert = true
                    } else if case .username = viewModel.authenticationJourney, username != "" {
                        profileViewModel.createUsername(username)
                    } else {
                        viewModel.nextJourney()
                    }
                } label: {
                    HStack {
                        Group {
                            HStack {
                                Spacer()
                                Text("Continue")
                                    .foregroundColor(.white)
                                    .font(.title3)
                                    .fontWeight(.bold)
                                Spacer()
                            }
                        }
                        .frame(height: 52)
                        .background($isInactive.wrappedValue ? Color("LoginColor2").opacity(0.25) : Color("LoginColor2"))
                        .cornerRadius(20)
                    }
                }
                .disabled($isInactive.wrappedValue)
            }
        }
    }
}

struct TextFieldWithColoredPlaceholder: View  {
    @Binding var text: String
    @Binding var placeholderText: String
    @Binding var placeholderColor: Color
    @Binding var canDismissKeyboard: Bool
    
    @FocusState private var fieldIsFocused: Bool
    
    var body: some View {
        ZStack {
            if $text.wrappedValue == "" {
                HStack {
                    Text($placeholderText.wrappedValue)
                        .multilineTextAlignment(.leading)
                        .foregroundColor(placeholderColor)
                        .font(.title3)
                    Spacer()
                }
            }
            
            HStack {
                TextField.init("", text: $text)
                    .introspectTextField { textField in
                        textField.becomeFirstResponder()
                    }
                    .foregroundColor(.white)
                    .frame(width: 195)
                    .focused($fieldIsFocused)
                    .font(.title3)
                    .onSubmit {
                        if !canDismissKeyboard {
                            fieldIsFocused = true
                        }
                    }
                Spacer()
            }
        }
        .onAppear {
            if !canDismissKeyboard {
                self.fieldIsFocused = true
            }
        }
    }
}

struct AuthenticationJourneyDecisionButtonView: View {
    @EnvironmentObject var viewModel: AuthenticationJourneyViewModel
    
    @State private var authJourney: AuthenticationJourneyPosition = .init()
    
    @Binding var didSkipProfilePhoto: Bool
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack {
                    HStack {
                        Spacer().frame(width: 11)
                        
                        Button {
                            viewModel.previousJourney()
                        } label: {
                            Image.init(systemName: "chevron.left")
                                .imageScale(.large)
                                .foregroundColor(.white)
                        }
                        .disabled(.rules == self.$authJourney.wrappedValue)
                        .opacity(.rules == self.$authJourney.wrappedValue ? 0 : 1)
                        .padding()
                        
                        Spacer()
                        
                        if case .profilePhoto = viewModel.authenticationJourney {
                            Button {
                                self.didSkipProfilePhoto = true 
                                
                                viewModel.nextJourney()
                            } label: {
                                Text("Skip")
                                    .foregroundColor(.white)
                                    .font(.body)
                                    .fontWeight(.thin)
                            }
                            .padding()
                            
                            Spacer().frame(width: 11)
                        }
                    }
                    
                    Spacer()
                }
            }
            .onChange(of: viewModel.authenticationJourney) { newValue in
                withAnimation(.easeInOut) {
                    self.authJourney = newValue
                }
            }
        }
    }
}
