//
//  OFProfileTabView.swift
//  OnlyFeet
//
//  Created by Fuad on 10/07/2022.
//

import SwiftUI

struct OFProfileTabView: View {
    @StateObject var viewModel = ProfileViewModel()
    
    @Environment(\.viewController) private var viewControllerHolder: UIViewController? 
    
    var body: some View {
        VStack {
            Button {
                viewModel.signOut()
            } label: {
                Text("Log OUT!")
                    .foregroundColor(Color.red)
            }
        }
        .onChange(of: viewModel.didSignOut) { didSignOut in 
            if didSignOut {
                self.viewControllerHolder?.present(style: .fullScreen) {
                    HomeAuthenticationView()
                }
            }
        }
    }
}

struct OFProfileTabView_Previews: PreviewProvider {
    static var previews: some View {
        OFProfileTabView()
    }
}
