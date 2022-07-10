//
//  AuthenticationJourneyNameView.swift
//  OnlyFeet
//
//  Created by Fuad on 27/06/2022.
//

import SwiftUI

struct AuthenticationJourneyNameView: View {
    @EnvironmentObject var viewModel: AuthenticationJourneyViewModel
    @Binding var displayName: String
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack {
                    HStack {
                        Spacer().frame(width: 50)
                        
                        Text("My name is")
                            .foregroundColor(.white)
                            .font(.largeTitle)
                        
                        Spacer()
                    }
                    
                    Spacer().frame(height: 40)
                    
                    HStack {
                        Spacer().frame(width: 50)
                        
                        TextFieldWithColoredPlaceholder.init(text: $displayName, placeholderText: .constant("Your name..."), placeholderColor: .constant(Color("CustomLightGray").opacity(0.4)), canDismissKeyboard: .constant(false))
                        
                        Spacer()
                    }
                    
                    HStack {
                        Spacer().frame(width: 50)
                        Rectangle.init().frame(width: 195, height: 4)
                            .foregroundColor(.white)
                        Spacer()
                    }
                    
                    Spacer().frame(height: 40)
                    
                    HStack {
                        Spacer().frame(width: 20)
                        
                        AuthenticationJourneyContinueButtonView.init(isInactive: .constant($displayName.wrappedValue.isEmpty), username: .constant(""))
                            .environmentObject(viewModel)
                        
                        Spacer().frame(width: 20)
                    }
                    
                    Spacer()
                }
            }
        }
    }
}
