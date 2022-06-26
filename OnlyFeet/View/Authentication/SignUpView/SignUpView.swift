//
//  SignUpView.swift
//  OnlyFeet
//
//  Created by Fuad on 23/06/2022.
//

import SwiftUI

struct SignUpView : View {
    @State var email = ""
    @State var password = ""
    @State var confirmPassword = ""
    @Binding var index : Int
    
    @FocusState private var emailIsFocused: Bool
    @FocusState private var passwordIsFocused: Bool
    @FocusState private var confirmPasswordIsFocused: Bool
    
    @EnvironmentObject var viewModel: AuthenticationViewModel<FeetishAuthentication>
    
    @State private var isRegistrationButtonDisabled = true
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                HStack {
                    Spacer(minLength: 0)
                    
                    VStack(spacing: 10) {
                        Text("REGISTER")
                            .foregroundColor(self.index == 1 ? .white : .gray)
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Capsule()
                            .fill(self.index == 1 ? Color.blue : Color.clear)
                            .frame(width: 100, height: 5)
                    }
                }
                .padding(.top, 30)
                
                VStack {
                    HStack(spacing: 15) {
                        Image(systemName: "envelope.fill")
                        .foregroundColor(Color("LoginColor2"))
                        
                        TextField("Email Address", text: self.$email)
                            .focused($emailIsFocused)
                            .disableAutocorrection(true)
                    }
                    
                    Divider().background(Color.white.opacity(0.5))
                }
                .padding(.horizontal)
                .padding(.top, 40)
                
                VStack {
                    HStack(spacing: 15) {
                        Image(systemName: "eye.slash.fill")
                        .foregroundColor(Color("LoginColor2"))
                        
                        SecureField("Password", text: self.$password)
                            .focused($passwordIsFocused)
                    }
                    
                    Divider().background(Color.white.opacity(0.5))
                }
                .padding(.horizontal)
                .padding(.top, 30)
                
                VStack {
                    HStack(spacing: 15) {
                        Image(systemName: "eye.slash.fill")
                        .foregroundColor(Color("LoginColor2"))
                        
                        SecureField("Confirm Password", text: self.$confirmPassword)
                            .focused($confirmPasswordIsFocused)
                    }
                    
                    Divider().background(Color.white.opacity(0.5))
                }
                .padding(.horizontal)
                .padding(.top, 30)
            }
            .padding()
            .padding(.bottom, 65)
            .background(Color("LoginColor3"))
            .clipShape(AuthenticationCurveShapeTwo())
            .contentShape(AuthenticationCurveShapeTwo())
            .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: -5)
            .onTapGesture {
                self.emailIsFocused = false
                self.passwordIsFocused = false
                self.confirmPasswordIsFocused = false
            
                self.index = 1
            }
            .cornerRadius(35)
            .padding(.horizontal,20)
             
            
            Button(action: {
                print("TAPPED!")
                self.emailIsFocused = false
                self.passwordIsFocused = false
                self.confirmPasswordIsFocused = false
                
                viewModel.createAccount(email: email, password: password, confirmedPassword: confirmPassword)
            }) {
                Text("REGISTER")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .padding(.vertical)
                    .padding(.horizontal, 50)
                    .background(Color("LoginColor2").opacity(isRegistrationButtonDisabled ? 0.5 : 1))
                    .clipShape(Capsule())
                    .shadow(color: Color.white.opacity(0.1), radius: 5, x: 0, y: 5)
            }
            .offset(y: 25)
            .opacity(self.index == 1 ? 1 : 0)
            .disabled(isRegistrationButtonDisabled)
        }
        .onTapGesture {
            print("TAPPED!")
            self.emailIsFocused = false
            self.passwordIsFocused = false
            self.confirmPasswordIsFocused = false
        }
        .onChange(of: email) { newValue in
            if !newValue.isEmpty && !self.password.isEmpty && !confirmPassword.isEmpty {
                self.isRegistrationButtonDisabled = false
            } else {
                self.isRegistrationButtonDisabled = true
            }
        }
        .onChange(of: password) { newValue in
            if !newValue.isEmpty && !self.password.isEmpty && !confirmPassword.isEmpty {
                self.isRegistrationButtonDisabled = false
            } else {
                self.isRegistrationButtonDisabled = true
            }
        }
        .onChange(of: confirmPassword) { newValue in
            if !newValue.isEmpty && !self.password.isEmpty && !confirmPassword.isEmpty {
                self.isRegistrationButtonDisabled = false
            } else {
                self.isRegistrationButtonDisabled = true
            }
        }
    }
}


