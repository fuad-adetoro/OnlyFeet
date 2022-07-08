//
//  OFCameraPhotoButton.swift
//  OnlyFeet
//
//  Created by Fuad on 08/07/2022.
//

import SwiftUI

struct OFCameraPhotoButton: View {
    @Binding var didTakePhoto: Bool
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                
                HStack {
                    Spacer()
                    
                    Button {
                        self.didTakePhoto = true
                    } label: {
                        ZStack {
                            Circle()
                                .fill(Color("LoginColor1").opacity(0.7))
                                .frame(width: 84, height: 84)
                            
                            Circle()
                                .fill(Color("LoginColor2"))
                                .frame(width: 72, height: 72)
                        }
                    }
                    
                    Spacer()
                }
                .frame(width: geometry.size.width, height: 85)
                
                Spacer().frame(height: 15)
            }
        }
    }
}
