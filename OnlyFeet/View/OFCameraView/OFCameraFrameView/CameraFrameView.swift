//
//  OFCameraFrameView.swift
//  OnlyFeet
//
//  Created by Fuad on 07/07/2022.
//

import SwiftUI

struct OFCameraFrameView: View {
    var image: CGImage?
    private let label = Text("Camera Feed")
    @Binding var cameraPosition: OFCameraPosition
    
    var body: some View {
        if let image = image {
            GeometryReader { geometry in
                Image(image, scale: 1.0, orientation: .upMirrored, label: label)
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
                    .clipped()
                    .scaleEffect(cameraPosition == .back ? CGSize(width: -1.0, height: 1.0) : CGSize(width: 1.0, height: 1.0))
            }
        } else {
            Color.black
        }
    }
}
