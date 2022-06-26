//
//  OnlyFeetApp.swift
//  OnlyFeet
//
//  Created by Fuad on 20/06/2022.
//

import SwiftUI
import FirebaseCore

@main
struct OnlyFeetApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            AuthenticationJourneyView()
        }
    }
}
