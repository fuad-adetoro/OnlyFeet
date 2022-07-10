//
//  OFCameraPurpose.swift
//  OnlyFeet
//
//  Created by Fuad on 08/07/2022.
//

import SwiftUI

struct OFCameraPurposeView: View {
    @EnvironmentObject var viewModel: OFCameraViewModel
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        ZStack {
            VStack {
                Spacer().frame(height: 15)
                
                ZStack {
                    Text(viewModel.cameraPurpose.purposeTitle())
                        .foregroundColor(.white)
                        .font(.title3)
                        .fontWeight(.bold)
                        .shadow(color: .black, radius: 1, x: 1, y: 1)
                    
                    if viewModel.cameraPurpose != .none {
                        HStack {
                            Spacer().frame(width: 15)
                            
                            Button {
                                presentationMode.wrappedValue.dismiss()
                            } label: {
                                Image(systemName: "xmark")
                                    .imageScale(.large)
                                    .foregroundColor(.white)
                                    .font(Font.title3.weight(.bold))
                                    .shadow(color: .black, radius: 1, x: 1, y: 1)
                            }
                            
                            Spacer()
                        }
                    }
                }
                
                Spacer()
            }
        }
    }
}
