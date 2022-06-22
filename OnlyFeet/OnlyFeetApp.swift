//
//  OnlyFeetApp.swift
//  OnlyFeet
//
//  Created by Fuad on 20/06/2022.
//

import SwiftUI
import FirebaseCore
import Combine

var testSubscriptions = Set<AnyCancellable>()

@main
struct OnlyFeetApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            HomeAuthenticationView()
                .onAppear {
                    DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + .seconds(4)) {
                        let publisher = FeetishAuthentication.shared.signUserOut()
                        
                        publisher
                            .subscribe(on: DispatchQueue.global(qos: .background))
                            .receive(on: DispatchQueue.main)
                            .sink { completion in
                                print("COMPLETED WITH: \(completion)")
                            } receiveValue: { value in
                                print("SIGNED OUT?: \(value)")
                            }
                            .store(in: &testSubscriptions)
                    }
                    

                }
        }
    }
}
