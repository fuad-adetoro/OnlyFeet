//
//  AuthenticationJourneyDateOfBirthSelectionView.swift
//  OnlyFeet
//
//  Created by Fuad on 27/06/2022.
//

import SwiftUI

struct AuthenticationJourneyDateOfBirthSelectionView: View {
    @EnvironmentObject var viewModel: AuthenticationJourneyViewModel
    
    @Binding var birthDate: Date
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack {
                    HStack {
                        Spacer().frame(width: 50)
                        
                        Text("My birthdate is")
                            .foregroundColor(.white)
                            .font(.largeTitle)
                        
                        Spacer()
                    }
                    
                    Spacer()
                }
                
                VStack {
                    Spacer().frame(height: 70)
                    DatePicker("", selection: $birthDate, in: viewModel.getCurrentDateClosedRange(), displayedComponents: .date)
                        .frame(width: geometry.size.width - 60)
                    .datePickerStyle(.graphical)
                    .colorMultiply(.black)
                    .colorInvert()
                    Spacer()
                }
                
                AuthenticationContinueButtonWithBackground.init(isInActive: .constant(false))
                .environmentObject(viewModel)
                .frame(height: geometry.size.height)
            }
        }
    }
}

struct AuthenticationJourneyDateOfBirthAlertView: View {
    @Binding var date: Date
    @Binding var isDisplayingAlert: Bool
    
    @EnvironmentObject var viewModel: AuthenticationJourneyViewModel
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                
                VStack {
                    HStack {
                        Spacer().frame(width: 40)
                        
                        VStack(spacing: 0) {
                            VStack {
                                Image.init(systemName: "calendar")
                                    .imageScale(.large)
                                    .foregroundColor(Color("LoginColor2"))
                                
                                Text("Please confirm.")
                                    .foregroundColor(Color("LoginColor2"))
                                    .font(.title3)
                                    .fontWeight(.bold)
                                
                                Text("My birthdate is \($date.wrappedValue.returnDateOfBirthAsString())")
                                    .foregroundColor(.black)
                                    .font(.body)
                                
                                /*Text("(Click the drop down again if having difficulties)")
                                    .foregroundColor(.black)
                                    .font(.footnote)*/
                            }
                            .frame(width: geometry.size.width - 80, height: 120)
                            .background(Color.white)
                            .cornerRadius(20, corners: [.topLeft, .topRight])
                            
                            VStack {
                                HStack {
                                    Button {
                                        withAnimation(.linear(duration: 0.2)) {
                                            self.isDisplayingAlert = false
                                        }
                                    } label: {
                                        Text("DENY")
                                            .foregroundColor(.white)
                                            .font(.body)
                                            .fontWeight(.bold)
                                            .frame(width: 120, height: 47)
                                            .background(Color("LoginColor2"))
                                            .cornerRadius(20, corners: [.bottomLeft])
                                    }
                                    
                                    Spacer()
                                    
                                    Button {
                                        withAnimation {
                                            self.isDisplayingAlert = false
                                        }
                                        
                                        self.viewModel.nextJourney()
                                    } label: {
                                        Text("Confirm")
                                            .foregroundColor(.white)
                                            .font(.body)
                                            .fontWeight(.bold)
                                            .frame(width: 120, height: 47)
                                            .background(Color.green)
                                            .cornerRadius(20, corners: [.bottomRight])
                                    }
                                }
                            }
                        }
                        
                        Spacer().frame(width: 40)
                    }
                    
                }
                .frame(width: geometry.size.width, height: 140)
                
                Spacer()
            }
            .frame(maxWidth: .infinity, minHeight: geometry.size.height, maxHeight: .infinity)
            .background(Color.black.opacity(0.4))
        }
    }
}
