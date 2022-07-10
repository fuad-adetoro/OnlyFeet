//
//  OFCameraTouchableView.swift
//  OnlyFeet
//
//  Created by Fuad on 08/07/2022.
//

import SwiftUI

struct OFCameraTouchableView: View {
    @Binding var currentFocusPoint: CGPoint
    @Binding var showingFocus: Bool
    @Binding var cameraPosition: OFCameraPosition
    
    @EnvironmentObject var viewModel: OFCameraViewModel
    
    var body: some View {
        OFCameraClickableBackground { location in
            self.currentFocusPoint = location
            
            withAnimation(.spring().repeatCount(2)) {
                self.showingFocus = true
            }
            
            viewModel.focus(location)
        } doubleTapCallback: {
            self.cameraPosition = cameraPosition.change()
            self.viewModel.changePosition()
        }
        .background(Color.clear)
        .edgesIgnoringSafeArea(.all)
    }
}
