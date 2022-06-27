//
//  AuthenticationJourneyRulesView.swift
//  OnlyFeet
//
//  Created by Fuad on 27/06/2022.
//

import SwiftUI

struct AuthenticationJourneyRulesView: View {
    @EnvironmentObject var viewModel: AuthenticationJourneyViewModel
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack {
                    Spacer().frame(height: 5)
                    
                    AuthenticationJourneyRulesHeaderIntroView.init()
                    
                    Spacer().frame(height: 25)
                    
                    AuthenticationJourneyAllRulesView.init()
                    
                    //Spacer().frame(height: 50)
                    
                    Spacer()
                }
                
                AuthenticationContinueButtonWithBackground.init(isInActive: .constant(false))
                    .environmentObject(viewModel)
                    .frame(height: geometry.size.height)
            }
        }
    }
}

struct AuthenticationJourneyRulesView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationJourneyRulesView()
    }
}

struct AuthenticationJourneyAllRulesView: View {
    var body: some View {
        GeometryReader { geometry in
            ScrollView.init {
                VStack {
                    AuthenticationJourneyRulesCheckView.init(title: .constant("Be yourself"), desription: .constant("Make sure you post your own content, select your real date of birth and please behave as you would in public."))
                    
                    Spacer().frame(height: 20)
                    
                    AuthenticationJourneyRulesCheckView.init(title: .constant("Stay safe"), desription: .constant("Do not send any user personal information or payment details."))
                    
                    // Do not send any personal details to users requesting
                    
                    Spacer().frame(height: 20)
                    
                    AuthenticationJourneyRulesCheckView.init(title: .constant("Content"), desription: .constant("Always report bad behaviour / content."))
                    
                    Spacer().frame(height: 20)
                    
                    AuthenticationJourneyRulesCheckView.init(title: .constant("Respect / Boundaries"), desription: .constant("Respect others and treat them as you would like to be treated."))
                    
                    VStack { Text("Show Nothing").foregroundColor(.clear) }.frame(height: 115)
                }
            }
        }
    }
}

struct AuthenticationJourneyRulesCheckView: View {
    @Binding var title: String
    @Binding var desription: String
    
    var body: some View {
        VStack {
            HStack {
                Spacer().frame(width: 25)
                
                Text.init(Image(systemName: "checkmark"))
                    .fontWeight(.bold)
                    .imageScale(.large)
                    .foregroundColor(Color("LoginColor2"))
                
                Text($title.wrappedValue)
                    .foregroundColor(.white)
                    .font(.body)
                    .fontWeight(.bold)
                
                Spacer()
            }
            
            Spacer().frame(height: 13.5)
            
            HStack {
                Spacer().frame(width: 25)
                
                Text($desription.wrappedValue)
                    .foregroundColor(.white)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Spacer()
            }
        }
    }
}

struct AuthenticationJourneyRulesHeaderIntroView: View {
    var body: some View {
        VStack {
            HStack {
                Spacer()
                
                Image.init("feetishRulesLogo")
                    .resizable()
                    .frame(width: 42, height: 67)
                
                Spacer()
            }
            
            Spacer().frame(height: 20)
            
            Text("Welcome to Feetish!")
                .foregroundColor(.white)
                .font(.title2)
                .fontWeight(.bold)
            
            Spacer().frame(height: 4)
            
            Text("Please follow all rules.")
                .foregroundColor(.white)
                .font(.subheadline)
                .fontWeight(.bold)
        }
    }
}
