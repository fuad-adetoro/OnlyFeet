//
//  FeetishBannerViewModel.swift
//  OnlyFeet
//
//  Created by Fuad on 22/06/2022.
//

import SwiftUI
import Foundation

public protocol FeetishBannerBased {
    func loadNewBanner(bannerData: FeetishBannerData)
    func removeCurrentBanner()
}

public class FeetishBannerViewModel: ObservableObject, FeetishBannerBased {
    static let shared = FeetishBannerViewModel.init()
    
    @Published var model: FeetishBannerData? = nil
    @Published var isTimeTicking = false
    @Published var isBeingDragged = false
    
    var timerForNotification: Timer? = nil
    
    var currentBannerTime: Int = 0
    let timeTarget: Int = 4
    
    public func loadNewBanner(bannerData: FeetishBannerData) {
        self.removeCurrentBanner()
        
        self.model = bannerData
        
        self.timerForNotification?.invalidate()
        self.timerForNotification = nil
        
        self.resumeRemovalTimer()
    }
    
    public func removeCurrentBanner() {
        withAnimation {
            self.model = nil
        }
    }
    
    public func resumeRemovalTimer() {
        currentBannerTime = 0
        isTimeTicking = true 
        
        timerForNotification = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [unowned self] timer in
            guard let _ = self.model else {
                // make sure we at least have a model :)
                return
            }
            
            if self.isBeingDragged {
                return
            }
            
            self.currentBannerTime = self.currentBannerTime + 1
            
            if self.currentBannerTime == 4 {
                self.timerForNotification?.invalidate()
                self.timerForNotification = nil
                
                print("REMOVE ALL")
                
                self.removeCurrentBanner()
                
                return
            }
        })
    }
}
