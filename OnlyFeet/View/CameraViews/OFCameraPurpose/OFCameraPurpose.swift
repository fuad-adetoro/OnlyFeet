//
//  OFCameraPurpose.swift
//  OnlyFeet
//
//  Created by Fuad on 08/07/2022.
//

import SwiftUI

struct OFCameraPurposeView: View {
    @Binding var cameraPurpose: OFCameraPurpose
    
    var body: some View {
        ZStack {
            VStack {
                Spacer().frame(height: 15)
                
                ZStack {
                    Text(cameraPurpose.purposeTitle())
                        .foregroundColor(.white)
                        .font(.title3)
                        .fontWeight(.bold)
                        .shadow(color: .black, radius: 1, x: 1, y: 1)
                    
                    if cameraPurpose != .none {
                        HStack {
                            Spacer().frame(width: 15)
                            
                            Button {
                                print("Back")
                            } label: {
                                Image(systemName: "chevron.backward")
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
