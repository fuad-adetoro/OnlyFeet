//
//  HomeAuthenticationView.swift
//  OnlyFeet
//
//  Created by Fuad on 21/06/2022.
//

import SwiftUI
import Combine

struct HomeAuthenticationView: View {
    @StateObject var viewModel = AuthenticationViewModel.init(feetishAuthentication: FeetishAuthentication.shared)
    
    @StateObject private var bannerViewModel = FeetishBannerViewModel()
    
    @State private var isLoading = false
    
    @Environment(\.viewController) private var viewControllerHolder: UIViewController?
    
    var body: some View {
            ZStack {
                AuthenticationHome()
                    .environmentObject(viewModel)
                    .disabled(viewModel.isChanging)
                    .preferredColorScheme(.dark)
                
                if isLoading {
                    FeetishBasicLoaderView(baseColor: .constant(.black), borderColor: .constant(.white), loadingText: .constant("Loading"))
                } 
            }
            .preferredColorScheme(.dark)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .modifier(FeetishBannerView(model: $bannerViewModel.model, isBeingDragged: $bannerViewModel.isBeingDragged))
             .onChange(of: viewModel.didResetPassword, perform: { newValue in
                if newValue {
                    self.bannerViewModel.loadNewBanner(bannerData: .init(title: "Success", message: "Please check your email.", bannerError: nil))
                }
            }) 
             .onChange(of: viewModel.didFetchAccount, perform: { didFetchAccount in
                 if didFetchAccount {
                     let doesAccountNeedJourney = FeetishUserJourney.shared.checkIfAccountJourneyIsNeeded()
                     
                     let isLoggedIn = FeetishUserJourney.shared.checkIfUserIsSignedIn()
                     
                     if isLoggedIn {
                         if doesAccountNeedJourney {
                             self.viewControllerHolder?.present(style: .fullScreen) {
                                 AuthenticationJourneyView()
                             }
                         } else {
                             self.viewControllerHolder?.present(style: .fullScreen) {
                                 OFTabView(doesHaveTopNotch: .constant(hasTopNotch))
                             }
                         }
                     }
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
                                .preferredColorScheme(.dark)
                            
                            LoginView(isShowingForgottenPasswordView: $isShowingForgottenPasswordView, index: self.$index)
                                .environmentObject(viewModel)
                                .preferredColorScheme(.dark)
                        }
                        

                    }
                    
                    if !isShowingForgottenPasswordView {
                        HStack(spacing: 15) {
                            Rectangle()
                            .fill(Color("LoginColor2"))
                            .frame(height: 1)
                            
                            Text("OR")
                                .foregroundColor(.white)
                            
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
        .onChange(of: index, perform: { _ in
            UIApplication.shared.keyWindow?.endEditing(true)
        })
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



