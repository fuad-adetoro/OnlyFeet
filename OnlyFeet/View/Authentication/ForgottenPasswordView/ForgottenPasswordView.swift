//
//  ForgottenPasswordView.swift
//  OnlyFeet
//
//  Created by Fuad on 23/06/2022.
//

import SwiftUI

struct ForgottenPasswordView : View {
    @State private var email = ""
    @State private var isSendResetButtonDisabled = true
    
    @EnvironmentObject var viewModel: AuthenticationViewModel
    
    @Binding var isShowingForgottenPasswordView: Bool
    
    var body: some View {
        VStack {
            ForgotPasswordHeaderView(isShowingForgottenPasswordView: $isShowingForgottenPasswordView)
            
            VStack {
                HStack(spacing: 15) {
                    Image(systemName: "envelope.fill")
                    .foregroundColor(Color("LoginColor2"))
                    
                    TextField("Email Address", text: self.$email)
                        .disableAutocorrection(true)
                }.padding([.leading, .trailing])
                
                Divider().background(Color.white.opacity(0.5))
                    .padding(.top, 10)
                
                Spacer()
            }
            
            Spacer().frame(height: 30)
            
            Button(action: {
                viewModel.sendPasswordRecovery(email: email)
            }) {
                
                Text("RESET")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .padding(.vertical)
                    .padding(.horizontal, 50)
                    .background(Color("LoginColor2").opacity(email.isEmpty ? 0.5 : 1))
                    .clipShape(Capsule())
                    .shadow(color: Color.white.opacity(0.1), radius: 5, x: 0, y: 5)
            }
            .disabled(email.isEmpty)
            .padding(.bottom, 40)
            
            Spacer()
        }
        .background(Color("LoginColor3"))
        .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: -5)
        .cornerRadius(35)
    }
}

struct ForgotPasswordHeaderView : View {
    @Binding var isShowingForgottenPasswordView: Bool
    
    var body: some View {
        VStack {
            Spacer().frame(height: 22)
            
            ZStack {
                HStack {
                    Spacer().frame(width: 15)
                    
                    Button {
                        withAnimation {
                            self.isShowingForgottenPasswordView = false
                        }
                    } label: {
                        Image(systemName: "arrow.down")
                            .imageScale(.large)
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                }
                
                HStack {
                    Spacer()
                    
                    Text("Forgotten Your Password?")
                        .bold()
                    
                    Spacer()
                }
            }
            
            Divider().background(Color.white.opacity(0.5))
                .padding(.top, 6)
            
            Spacer().frame(height: 20)
            
            HStack {
                Spacer().frame(width: 20)
                
                Text("Enter your **email**:")
                    .multilineTextAlignment(.leading)
                    .font(.body)
                
                Spacer()
            }
            
            Spacer().frame(height: 10)
        }
    }
}
