//
//  OFCameraViewerView.swift
//  OnlyFeet
//
//  Created by Fuad on 07/07/2022.
//

import SwiftUI
 
struct OFCameraViewerView: View {
    @StateObject private var viewModel = OFCameraViewModel()
    
    @State private var didTakePhoto = false
    
    @Binding var cameraPurpose: OFCameraPurpose
    
    @State private var cameraPosition: OFCameraPosition = .back
    
    @State private var showingFocus = false
    @State private var currentFocusPoint: CGPoint = CGPoint(x: 0, y: 0)
    
    var body: some View {
        ZStack {
            CameraFrameView(image: viewModel.frame, cameraPosition: $cameraPosition)
                .edgesIgnoringSafeArea(.all)
            
            OFCameraErrorView(error: viewModel.error)
            
            OFCameraPurposeView(cameraPurpose: $cameraPurpose)
            
            if showingFocus {
                OFCameraFocusPointView(currentFocusPoint: $currentFocusPoint, showingFocus: $showingFocus)
            }
            
            OFCameraTouchableView(currentFocusPoint: $currentFocusPoint, showingFocus: $showingFocus, cameraPosition: $cameraPosition)
                .environmentObject(viewModel) 
            
            OFCameraPhotoButton(didTakePhoto: $didTakePhoto)
        }
    }
}

struct OFCameraViewerView_Previews: PreviewProvider {
    static var previews: some View {
        OFCameraViewerView(cameraPurpose: .constant(.profilePhotoFromAuth))
    }
}
