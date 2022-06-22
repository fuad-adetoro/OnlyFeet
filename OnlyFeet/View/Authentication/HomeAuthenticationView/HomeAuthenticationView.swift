//
//  HomeAuthenticationView.swift
//  OnlyFeet
//
//  Created by Fuad on 21/06/2022.
//

import SwiftUI
import Combine

struct HomeAuthenticationView: View {
    @ObservedObject var viewModel = AuthenticationViewModel()
    
    var body: some View {
        ZStack {
            AuthenticationHome()
                .preferredColorScheme(.dark)
                .environmentObject(viewModel)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct FeetishMainLoginView_Previews: PreviewProvider {
    static var previews: some View {
        HomeAuthenticationView()
    }
}

struct AuthenticationHome: View {
    @State var index = 0
    
    @EnvironmentObject var viewModel: AuthenticationViewModel
    
    var body: some View{
        GeometryReader{ geometry in
            
            ScrollView.init {
                VStack{
                    Spacer()
                    
                    Image("newAuthLogo")
                        .resizable()
                        .frame(width: 71, height: 114)
                    
                    
                    ZStack{
                        
                        SignUpView(index: self.$index)
                            .zIndex(Double(self.index))
                            .environmentObject(viewModel)
                        
                        LoginView(index: self.$index)
                            .environmentObject(viewModel)

                    }
                    
                    HStack(spacing: 15) {
                        Rectangle()
                        .fill(Color("LoginColor2"))
                        .frame(height: 1)
                        
                        Text("OR")
                        
                        Rectangle()
                        .fill(Color("LoginColor2"))
                        .frame(height: 1)
                    }
                    .padding(.horizontal, 30)
                    .padding(.top, 50)
                    
                    HStack(spacing: 25) {
                        Button(action: {
                            
                        }) {
                            Image("loginGmail")
                        }
                        
                        Button(action: {
                            
                        }) {
                            Image("loginApple")
                        }
                    }
                    .padding(.top, 30)
                    
                    Spacer()
                }
                .padding(.vertical)
                .onTapGesture {
                    self.hideKeyboard()
                }
                .frame(maxWidth: .infinity, minHeight: geometry.size.height, maxHeight: .infinity)
            }
        }
        .background(Image("AuthBG")
            .resizable()
            .scaledToFill()
            .edgesIgnoringSafeArea(.all)
        )
    }
}

struct LoginView : View {
    @State var email = ""
    @State var password = ""
    @Binding var index : Int
    
    @EnvironmentObject var viewModel: AuthenticationViewModel
    
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
                        
                        TextField("Email Address or Username", text: self.$email)
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
                    }
                    
                    Divider().background(Color.white.opacity(0.5))
                }
                .padding(.horizontal)
                .padding(.top, 30)
                
                HStack {
                    Spacer(minLength: 0)
                    
                    Button(action: {
                        
                    }) {
                        Text("Forgot Password?")
                            .foregroundColor(Color.white.opacity(0.6))
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
                viewModel.signUserIn(email: email, password: password)
            }) {
                
                Text("LOGIN")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .padding(.vertical)
                    .padding(.horizontal, 50)
                    .background(Color("LoginColor2"))
                    .clipShape(Capsule())
                    .shadow(color: Color.white.opacity(0.1), radius: 5, x: 0, y: 5)
            } 
            .offset(y: 25)
            .opacity(self.index == 0 ? 1 : 0)
        }
    }
}

struct SignUpView : View {
    @State var email = ""
    @State var password = ""
    @State var confirmPassword = ""
    @Binding var index : Int 
    
    @FocusState private var emailIsFocused: Bool
    @FocusState private var passwordIsFocused: Bool
    @FocusState private var confirmPasswordIsFocused: Bool
    
    @EnvironmentObject var viewModel: AuthenticationViewModel
    
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
                    .background(Color("LoginColor2"))
                    .clipShape(Capsule())
                    .shadow(color: Color.white.opacity(0.1), radius: 5, x: 0, y: 5)
            }
            .offset(y: 25)
            .opacity(self.index == 1 ? 1 : 0)
        }
        .onTapGesture {
            print("TAPPED!")
            self.emailIsFocused = false
            self.passwordIsFocused = false
            self.confirmPasswordIsFocused = false
        }
    }
}
