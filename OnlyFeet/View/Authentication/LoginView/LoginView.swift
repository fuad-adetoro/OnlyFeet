//
//  LoginView.swift
//  OnlyFeet
//
//  Created by Fuad on 23/06/2022.
//

import SwiftUI

struct LoginView : View {
    @Binding var isShowingForgottenPasswordView: Bool
    
    @State private var email = ""
    @State private var password = ""
    @Binding var index : Int
    
    @EnvironmentObject var viewModel: AuthenticationViewModel<FeetishAuthentication>
    
    @State private var isLoginButtonDisabled = true
    
    @FocusState private var emailIsFocused: Bool
    @FocusState private var passwordIsFocused: Bool 
    
    var body: some View{
        ZStack(alignment: .bottom) {
            VStack {
                HStack {
                    VStack(spacing: 10) {
                        Text("LOGIN")
                            .foregroundColor(self.index == 0 ? .white : .gray)
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Capsule()
                            .fill(self.index == 0 ? Color.blue : Color.clear)
                            .frame(width: 100, height: 5)
                    }
                    
                    Spacer(minLength: 0)
                }
                .padding(.top, 30)
                
                VStack {
                    HStack(spacing: 15) {
                        Image(systemName: "envelope.fill")
                        .foregroundColor(Color("LoginColor2"))
                        
                        TextField("", text: self.$email)
                            .focused($emailIsFocused)
                            .disableAutocorrection(true)
                            .placeholder(when: self.$email.wrappedValue.isEmpty, placeholder: {
                                Text("Email Address or Username")
                                    .foregroundColor(.gray)
                            })
                            .foregroundColor(.white)
                            .onSubmit {
                                self.passwordIsFocused = true
                            }
                            .submitLabel(.next)
                    }
                    
                    Divider().background(Color.white.opacity(0.5))
                }
                .padding(.horizontal)
                .padding(.top, 40)
                
                VStack {
                    HStack(spacing: 15) {
                        Image(systemName: "eye.slash.fill")
                        .foregroundColor(Color("LoginColor2"))
                        
                        SecureField("", text: self.$password)
                            .focused($passwordIsFocused)
                            .placeholder(when: self.$password.wrappedValue.isEmpty, placeholder: {
                                Text("Password")
                                    .foregroundColor(.gray)
                            })
                            .foregroundColor(.white)
                            .onSubmit {
                                self.passwordIsFocused = false
                                self.emailIsFocused = false
                                
                                viewModel.signUserIn(email: email, password: password)
                            }
                            .submitLabel(.continue)
                    }
                    
                    Divider().background(Color.white.opacity(0.5))
                }
                .padding(.horizontal)
                .padding(.top, 30)
                
                HStack {
                    Spacer(minLength: 0)
                    
                    Button(action: {
                        withAnimation {
                            self.isShowingForgottenPasswordView = true
                        }
                    }) {
                        Text("Forgot Password?")
                            .foregroundColor(Color.white.opacity(0.6))
                            .underline()
                    }
                }
                .padding(.horizontal)
                .padding(.top, 30)
            }
            .padding()
            .padding(.bottom, 65)
            .background(Color("LoginColor3"))
            .clipShape(AuthenticationCurveShapeOne())
            .contentShape(AuthenticationCurveShapeOne())
            .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: -5)
            .onTapGesture {
                self.index = 0
            }
            .cornerRadius(35)
            .padding(.horizontal,20)
            
            Button(action: {
                self.emailIsFocused = false
                self.passwordIsFocused = false
                
                viewModel.signUserIn(email: email, password: password)
            }) {
                
                Text("LOGIN")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .padding(.vertical)
                    .padding(.horizontal, 50)
                    .background(Color("LoginColor2").opacity(isLoginButtonDisabled ? 0.5 : 1))
                    .clipShape(Capsule())
                    .shadow(color: Color.white.opacity(0.1), radius: 5, x: 0, y: 5)
            }
            .offset(y: 25)
            .opacity(self.index == 0 ? 1 : 0)
            .disabled(isLoginButtonDisabled)
        }
        .onChange(of: email) { newValue in
            if !newValue.isEmpty && !self.password.isEmpty {
                self.isLoginButtonDisabled = false
            } else {
                self.isLoginButtonDisabled = true
            }
        }
        .onChange(of: password) { newValue in
            if !newValue.isEmpty && !self.email.isEmpty {
                self.isLoginButtonDisabled = false
            } else {
                self.isLoginButtonDisabled = true
            }
        }
    }
}
