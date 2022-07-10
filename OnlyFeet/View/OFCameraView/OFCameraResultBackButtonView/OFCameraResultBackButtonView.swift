//
//  OFCameraResultBackButtonView.swift
//  OnlyFeet
//
//  Created by Fuad on 08/07/2022.
//

import SwiftUI

struct OFCameraResultBackButtonView: View {
    @Binding var title: String?
    
    @EnvironmentObject var viewModel: OFCameraViewModel
    
    var body: some View {
        VStack {
            Spacer().frame(height: 15)
            
            ZStack {
                HStack {
                    Spacer().frame(width: 15)
                    
                    Button {
                        viewModel.removeTakenPhoto()
                    } label: {
                        Image(systemName: "xmark")
                            .imageScale(.large)
                            .foregroundColor(.white)
                            .font(Font.title3.weight(.bold))
                            .shadow(color: .black, radius: 1, x: 1, y: 1)
                    }

                    
                    Spacer()
                }
                
                if let title = title {
                    HStack {
                        Spacer()
                        
                        Text(title)
                            .foregroundColor(.white)
                            .font(.title3)
                            .fontWeight(.bold)
                            .shadow(color: .black, radius: 1, x: 1, y: 1)
                        Spacer()
                    }
                }
                
                HStack {
                    Spacer()
                    
                    Button {
                        self.viewModel.savePhoto()
                    } label: {
                        Text("Save!")
                            .foregroundColor(.white)
                            .font(.title3)
                            .fontWeight(.bold)
                            .shadow(color: .black, radius: 1, x: 1, y: 1)
                    }
                    
                    Spacer().frame(width: 15)
                }
            }
            
            Spacer()
        }
    }
}

struct OFCameraResultBackButtonView_Previews: PreviewProvider {
    static var previews: some View {
        OFCameraResultBackButtonView(title: .constant(nil))
    }
}
