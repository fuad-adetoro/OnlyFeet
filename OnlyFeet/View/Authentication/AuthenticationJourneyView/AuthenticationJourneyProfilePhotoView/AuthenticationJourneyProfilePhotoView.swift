//
//  AuthenticationJourneyProfilePhotoView.swift
//  OnlyFeet
//
//  Created by Fuad on 27/06/2022.
//

import SwiftUI

struct AuthenticationJourneyProfilePhotoUploaderView: View {
    @EnvironmentObject var viewModel: AuthenticationJourneyViewModel
    
    @Binding var isImagePickerDisplayed: Bool
    @Binding var profileImage: UIImage?
    
    @Binding var croppedImage: UIImage?
    @State private var imageCroppingViewShown = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack {
                    HStack {
                        Spacer().frame(width: 50)
                        
                        Text("Please provide a profile picture")
                            .foregroundColor(.white)
                            .font(.largeTitle)
                            .onChange(of: profileImage) { newValue in
                                if let _ = newValue {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(280)) {
                                        self.imageCroppingViewShown = true
                                    }
                                }
                            }
                        
                        Spacer()
                    }
                    
                    Spacer().frame(height: 50)
                    
                    HStack {
                        Spacer()
                        
                        Button {
                            self.isImagePickerDisplayed = true
                        } label: {
                            ZStack {
                                VStack {
                                    AuthenticationJourneyProfilePhotoCircleView
                                        .init(backgroundColor: .constant(.gray),
                                              initialSize: .constant(.init(width: 146, height: 146)),
                                              secondarySize: .constant(.init(width: 150, height: 150)),
                                              borderColor: .constant(.black),
                                              secondaryBorderColor: .constant(Color("LoginColor2")),
                                              borderWidth: .constant(4.0), profileImage: $croppedImage
                                        )
                                }
                                .frame(width: 150, height: 150)
                                
                                if $profileImage.wrappedValue == nil {
                                    VStack {
                                        Spacer()
                                        
                                        HStack {
                                            Spacer()
                                            
                                            AuthenticationJourneyProfilePhotoPlusButtonView.init()
                                                .frame(width: 28, height: 28)
                                            
                                            Spacer().frame(width: 15)
                                        }
                                    }
                                    .frame(width: 150, height: 150)
                                }
                            }
                            .frame(width: 150, height: 150)
                        }
                        
                        
                        Spacer()
                    }
                    
                    Spacer()
                }
                .sheet(isPresented: $imageCroppingViewShown) {
                    FeetishImageCroppingView(shown: $imageCroppingViewShown, image: profileImage!, croppedImage: $croppedImage)
                }
                
                AuthenticationContinueButtonWithBackground.init(isInActive: .constant(croppedImage == nil))
                .environmentObject(viewModel)
                .frame(height: geometry.size.height)
            }
        }
    }
}

struct AuthenticationJourneyProfilePhotoCircleView: View {
    @Binding var backgroundColor: Color
    @Binding var initialSize: CGSize
    
    @Binding var secondarySize: CGSize
    
    @Binding var borderColor: Color
    @Binding var secondaryBorderColor: Color
    @Binding var borderWidth: CGFloat
    
    @Binding var profileImage: UIImage?
    
    var body: some View {
        ZStack {
            HStack {
                Spacer()
                
                if let profileImage = profileImage {
                    Image.init(uiImage: profileImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: $initialSize.wrappedValue.width, height: $initialSize.wrappedValue.height, alignment: .center)
                        .cornerRadius($initialSize.wrappedValue.width / 2)
                        .clipped()
                } else {
                    Circle.init()
                        .fill($backgroundColor.wrappedValue)
                        .frame(width: $initialSize.wrappedValue.width, height: $initialSize.wrappedValue.height)
                }
                
                Spacer()
            }
            
            HStack {
                Spacer()
                
                Circle.init()
                    .strokeBorder($profileImage.wrappedValue == nil ? $borderColor.wrappedValue : $secondaryBorderColor.wrappedValue, lineWidth: $borderWidth.wrappedValue)
                    .frame(width: $secondarySize.wrappedValue.width, height: $secondarySize.wrappedValue.height)
                
                Spacer()
            }
        }
    }
}

struct AuthenticationJourneyProfilePhotoPlusButtonView: View {
    @EnvironmentObject var viewModel: AuthenticationJourneyViewModel
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Spacer()
                
                HStack {
                    Spacer()
                    
                    Circle.init()
                        .fill(Color("LoginColor2"))
                        .frame(width: 28, height: 28)
                    
                    Spacer()
                }
                .frame(width: 28, height: 28)
                
                Spacer()
            }
            
            VStack(spacing: 0) {
                Spacer()
                
                HStack {
                    Spacer()
                    
                    Image.init(systemName: "plus")
                        .imageScale(.medium)
                        .foregroundColor(.white)
                    
                    Spacer()
                }
                .frame(width: 28, height: 28)
                
                Spacer()
            }
        }
    }
}
