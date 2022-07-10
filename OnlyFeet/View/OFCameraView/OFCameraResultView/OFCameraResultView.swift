//
//  OFCameraResultView.swift
//  OnlyFeet
//
//  Created by Fuad on 08/07/2022.
//

import SwiftUI

struct OFCameraResultView: View {
    @EnvironmentObject var viewModel: OFCameraViewModel
    
    private let label = Text("Camera Result")
    @Binding var cameraPosition: OFCameraPosition
    
    var body: some View {
        if let image = viewModel.takenPhoto {
            GeometryReader { geometry in
                ZStack {
                    VStack {
                        Spacer()
                        
                        Image(image, scale: 1.0, orientation: .upMirrored, label: label)
                            .resizable()
                            .scaledToFill()
                            .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
                            .clipped()
                            .scaleEffect(cameraPosition == .back ? CGSize(width: -1.0, height: 1.0) : CGSize(width: 1.0, height: 1.0))
                        
                        Spacer()
                    }
                    .edgesIgnoringSafeArea(.all)
                    
                    OFCameraResultBackButtonView(title: .constant(viewModel.cameraPurpose.purposeTitle()))
                        .environmentObject(viewModel)
                }
            }
            .navigationBarHidden(true)
        } else {
            ZStack {
                Color.black
                
                OFCameraResultBackButtonView(title: .constant(viewModel.cameraPurpose.purposeTitle()))
            }
        }
    }
}


