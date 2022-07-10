//
//  OFTabViewModel.swift
//  OnlyFeet
//
//  Created by Fuad on 10/07/2022.
//

import Foundation
import SwiftUI
import Combine

protocol OFTabBased {
    func makeView() -> AnyView
    func updateTab(_ tab: OFTab)
}

class OFTabViewModel: ObservableObject, OFTabBased {
    @Published var currentTab: OFTab = .home
    
    func makeView() -> AnyView { 
        switch currentTab {
        case .home:
            return AnyView(OFHomeTabView())
        case .search:
            return AnyView(OFSearchTabView())
        case .activity:
            return AnyView(OFActivityTabView())
        case .profile:
            return AnyView(OFProfileTabView())
        }
    }
    
    func updateTab(_ tab: OFTab) {
        self.currentTab = tab
    }
}
