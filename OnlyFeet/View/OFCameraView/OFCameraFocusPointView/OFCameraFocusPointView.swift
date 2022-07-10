//
//  OFCameraFocusPointView.swift
//  OnlyFeet
//
//  Created by Fuad on 08/07/2022.
//

import SwiftUI

struct OFCameraFocusPointView: View {
    @Binding var currentFocusPoint: CGPoint
    @Binding var showingFocus: Bool 
    
    var body: some View {
        Image("cameraFocusIMG")
            .position(currentFocusPoint)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(2500)) {
                self.showingFocus = false
            }
        }
    }
}
