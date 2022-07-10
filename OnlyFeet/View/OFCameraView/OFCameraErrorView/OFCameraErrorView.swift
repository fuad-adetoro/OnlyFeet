//
//  OFCameraErrorView.swift
//  OnlyFeet
//
//  Created by Fuad on 07/07/2022.
//

import SwiftUI

struct OFCameraErrorView: View {
    var error: Error?
    
    var body: some View {
        VStack {
            Text(error?.localizedDescription ?? "")
                .bold()
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding(8)
                .foregroundColor(.white)
                .background(Color.red.edgesIgnoringSafeArea(.top))
                .opacity(error == nil ? 0.0 : 1.0)
                .animation(.easeInOut, value: 0.25)
            
            Spacer()
        }
    }
}

struct OFCameraErrorView_Previews: PreviewProvider {
    static var previews: some View {
        OFCameraErrorView(error: OFCameraError.cannotAddInput)
    }
}
