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
    
    @State private var cameraPosition: OFCameraPosition = .back
    
    @State private var showingFocus = false
    @State private var currentFocusPoint: CGPoint = CGPoint(x: 0, y: 0)
    
    @Binding var cameraPurpose: OFCameraPurpose
    @Binding var profileImage: UIImage?
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        ZStack {
            if let _ = viewModel.takenPhoto {
                OFCameraResultView(cameraPosition: $cameraPosition)
                    .environmentObject(viewModel)
            } else {
                OFCameraFrameView(image: viewModel.frame, cameraPosition: $cameraPosition)
                    .edgesIgnoringSafeArea(.all)
                    .onAppear {
                        viewModel.set(cameraPurpose: cameraPurpose)
                    }
                
                OFCameraErrorView(error: viewModel.error)
                 
                if showingFocus {
                    OFCameraFocusPointView(currentFocusPoint: $currentFocusPoint, showingFocus: $showingFocus)
                }
                
                OFCameraTouchableView(currentFocusPoint: $currentFocusPoint, showingFocus: $showingFocus, cameraPosition: $cameraPosition)
                    .environmentObject(viewModel)
                
                OFCameraPurposeView()
                    .environmentObject(viewModel)
                
                OFCameraPhotoButton(didTakePhoto: $didTakePhoto)
                    .onChange(of: didTakePhoto) { _ in
                        if didTakePhoto {
                            viewModel.takePhoto()
                            self.didTakePhoto = false
                        }
                    }
            }
        }
        .onChange(of: viewModel.savedPhoto) { savedPhoto in
            guard let savedPhoto = savedPhoto else {
                return
            }
             
            self.profileImage = savedPhoto
            
            self.presentationMode.wrappedValue.dismiss()
        }
    }
}

struct OFCameraViewerView_Previews: PreviewProvider {
    static var previews: some View {
        OFCameraViewerView(cameraPurpose: .constant(.profilePhotoFromAuth), profileImage: .constant(nil))
    }
}
