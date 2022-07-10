//
//  FeetishBasicLoaderView.swift
//  OnlyFeet
//
//  Created by Fuad on 23/06/2022.
//

import SwiftUI

struct FeetishBasicLoaderView: View {
    @Binding var baseColor: Color
    @Binding var borderColor: Color
    @Binding var loadingText: String
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                
                ZStack {
                    
                    RoundedRectangle(cornerRadius: 10)
                        .fill(borderColor)
                        .frame(width: 90, height: 90)
                    
                    RoundedRectangle(cornerRadius: 10)
                        .fill(baseColor)
                        .frame(width: 88, height: 88)
                    
                    ProgressView(loadingText)
                        .foregroundColor(.white)
                        .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                        
                }
                .frame(width: 90, height: 90)
                
                Spacer()
            }.frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
}
