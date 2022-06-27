//
//  AuthenticationJourneyGenderView.swift
//  OnlyFeet
//
//  Created by Fuad on 27/06/2022.
//

import Foundation
import SwiftUI

struct AuthenticationJourneyGenderSelectionView: View {
    @Binding var gender: FeetishGender
    
    @EnvironmentObject var viewModel: AuthenticationJourneyViewModel
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack {
                    HStack {
                        Spacer().frame(width: 50)
                        
                        Text("I am")
                            .foregroundColor(.white)
                            .font(.largeTitle)
                        
                        Spacer()
                    }
                    
                    Spacer()
                }
                
                VStack {
                    Spacer()
                    
                    VStack {
                        HStack {
                            Spacer().frame(width: 60)
                            
                            AuthenticationJourneyGenderSelectorView.init(isSelected: .constant(.male == gender ? true : false), image: .constant("👦".textToImage()!), title: .constant("A Man"), gender: $gender)
                            
                            Spacer()
                            
                            AuthenticationJourneyGenderSelectorView.init(isSelected: .constant(.female == gender ? true : false), image: .constant("👧".textToImage()!), title: .constant("A Woman"), gender: $gender)
                            Spacer()
                        }
                        
                        Spacer().frame(height: 20)
                        
                        HStack {
                            Spacer()
                            
                            AuthenticationJourneyGenderSelectorView.init(isSelected: .constant(.unspecified == gender ? true : false), image: .constant("👩‍🦲".textToImage()!), title: .constant("Unspecified"), gender: $gender)
                            
                            Spacer()
                        }
                    }
                    .frame(width: geometry.size.width, height: 140)
                    
                    Spacer().frame(height: 150)
                    Spacer()
                }
                
                AuthenticationContinueButtonWithBackground.init(isInActive: .none == $gender.wrappedValue ? .constant(true) : .constant(false))
                .environmentObject(viewModel)
                .frame(height: geometry.size.height)
            }
        }
    }
}

struct AuthenticationJourneyGenderSelectorView: View {
    @Binding var isSelected: Bool
    @Binding var image: UIImage
    @Binding var title: String
    
    @Binding var gender: FeetishGender
    
    var body: some View {
        Button {
            let textTitle = title.lowercased()
            
            withAnimation(.linear(duration: 0.25)) {
                if textTitle.contains("wo") {
                    gender = .female
                } else if textTitle == "unspecified" {
                    gender = .unspecified
                } else {
                    gender = .male
                }
            }
        } label: {
            ZStack {
                VStack {
                    Image(uiImage: image)
                        .resizable()
                        .frame(width: 80, height: 80)
                    
                    Text(title)
                        .foregroundColor(.white)
                        .font(title.lowercased() == "unspecified" ? .body : .title2)
                        .fontWeight(.bold)
                }
                .frame(width: 100, height: 100)
                
                VStack {
                    EmptyView.init()
                }
                .frame(width: 125, height: 125)
                .background(isSelected ? Color.gray.opacity(0.3) : Color.black.opacity(0.58))
                .cornerRadius(12)
                
                if isSelected {
                    VStack {
                        EmptyView.init()
                    }
                    .frame(width: 125, height: 125)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color("LoginColor2"), lineWidth: 3.8)
                    )
                }
            }
        }
    }
}

