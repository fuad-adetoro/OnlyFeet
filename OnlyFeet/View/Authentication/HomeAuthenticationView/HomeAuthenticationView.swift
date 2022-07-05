//
//  HomeAuthenticationView.swift
//  OnlyFeet
//
//  Created by Fuad on 21/06/2022.
//

import SwiftUI
import Combine

struct HomeAuthenticationView: View {
    @ObservedObject var viewModel = AuthenticationViewModel.init(feetishAuthentication: FeetishAuthentication.shared)
    
    @ObservedObject private var bannerViewModel = FeetishBannerViewModel()
    
    @State private var isLoading = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                AuthenticationHome()
                    .preferredColorScheme(.dark)
                    .environmentObject(viewModel)
                    .disabled(viewModel.isChanging)
                
                if isLoading {
                    FeetishBasicLoaderView(baseColor: .constant(.black), borderColor: .constant(.white), loadingText: .constant("Loading"))
                } 
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .modifier(FeetishBannerView(model: $bannerViewModel.model, isBeingDragged: $bannerViewModel.isBeingDragged))
             .onChange(of: viewModel.didResetPassword, perform: { newValue in
                if newValue {
                    self.bannerViewModel.loadNewBanner(bannerData: .init(title: "Success", message: "Please check your email.", bannerError: nil))
                }
            })
            .onChange(of: viewModel.isChanging, perform: { newValue in
                withAnimation {
                    self.isLoading = newValue
                }
            })
            .onChange(of: viewModel.didErrorOccur) { hasError in
                if hasError {
                    withAnimation {
                        self.bannerViewModel.loadNewBanner(bannerData: .init(title: nil, message: viewModel.feetishAuthError?.errorDescription ?? FeetishAuthError.unknownError.localizedDescription, bannerError: viewModel.feetishAuthError ?? .unknownError))
                    }
                }
            }
        }
    }
}

struct FeetishMainLoginView_Previews: PreviewProvider {
    static var previews: some View {
        HomeAuthenticationView()
    }
}

struct AuthenticationHome: View {
    @State var index = 0
    
    @EnvironmentObject var viewModel: AuthenticationViewModel<FeetishAuthentication>
    
    @State private var isShowingForgottenPasswordView = false
    
    var body: some View {
        GeometryReader{ geometry in
            
            ScrollView.init {
                VStack{
                    Spacer()
                    
                    Image("newAuthLogo")
                        .resizable()
                        .frame(width: 71, height: 114)
                    
                    if isShowingForgottenPasswordView {
                        Spacer()
                    }
                    
                    ZStack{
                        if isShowingForgottenPasswordView {
                            ForgottenPasswordView(isShowingForgottenPasswordView: $isShowingForgottenPasswordView)
                                .environmentObject(viewModel)
                                .frame(width: geometry.size.width - 40, height: geometry.size.height / 1.3)
                        } else {
                            SignUpView(index: self.$index)
                                .zIndex(Double(self.index))
                                .environmentObject(viewModel)
                            
                            LoginView(isShowingForgottenPasswordView: $isShowingForgottenPasswordView, index: self.$index)
                                .environmentObject(viewModel)
                        }
                        

                    }
                    
                    if !isShowingForgottenPasswordView {
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
                    }
                    
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
        .onChange(of: viewModel.didResetPassword) { newValue in
            if newValue {
                DispatchQueue.main.async {
                    withAnimation {
                        self.isShowingForgottenPasswordView = false
                    }
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5)) {
                    viewModel.didResetPassword = false
                }
            }
        }
    }
}



