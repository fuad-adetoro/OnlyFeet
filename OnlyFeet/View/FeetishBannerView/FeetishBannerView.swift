//
//  FeetishBannerView.swift
//  OnlyFeet
//
//  Created by Fuad on 22/06/2022.
//

import SwiftUI

struct FeetishBannerView: ViewModifier {
    @Binding var model: FeetishBannerData?
    @Binding var isBeingDragged: Bool
     
    @State private var offset = CGSize.zero
    
    func body(content: Content) -> some View {
        content.overlay(
            VStack {
                if model != nil {
                    VStack {
                        ZStack {
                            /*HStack {
                                Spacer().frame(width: 15)
                                
                                Image(systemName: "exclamationmark.triangle.fill")
                                
                                Spacer()
                            }*/
                            
                            HStack {
                                if let _ = self.model?.bannerError as? FeetishAuthError {
                                    Spacer()
                                    
                                    VStack {
                                        if let title = self.model?.title, let errorMessage = self.model?.message {
                                            Text(title)
                                                .font(.headline)
                                            Text(errorMessage)
                                                .font(.subheadline)
                                                .multilineTextAlignment(.center)
                                        } else if let title = self.model?.title {
                                            Text(title)
                                                .font(.headline)
                                        } else if let errorMessage = self.model?.message {
                                            Text(errorMessage)
                                                .font(.headline)
                                                .multilineTextAlignment(.center)
                                        } else {
                                            Text("Something went wrong!")
                                                .font(.headline)
                                        }
                                    }
                                    
                                    Spacer()
                                }
                            }
                        }
                        .padding()
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .foregroundColor(.white)
                        .background(Color.red)
                        .cornerRadius(10)
                        .shadow(radius: 10)
                        .offset(x: 0, y: offset.height)
                        
                        Spacer()
                    }
                    .padding()
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                self.isBeingDragged = true
                                
                                if offset.height > 40 {
                                    return
                                } else {
                                    withAnimation(.spring()) {
                                        offset = gesture.translation
                                    }
                                }
                            }
                            .onEnded({ _ in
                                self.isBeingDragged = false
                                
                                withAnimation(.spring()) {
                                    if offset.height < 0 {
                                        if (abs(offset.height) > 65) {
                                            offset.height = -500
                                            
                                            DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + .milliseconds(200)) {
                                                DispatchQueue.main.async {
                                                    self.model = nil
                                                    self.offset = .zero
                                                }
                                            }
                                        } else {
                                            offset = .zero
                                        }
                                    } else {
                                        offset = .zero
                                    }
                                }
                            })
                    )
                }
            }
        )
    }
}
