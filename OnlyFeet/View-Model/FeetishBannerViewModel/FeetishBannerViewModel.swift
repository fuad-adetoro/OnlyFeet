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

public final class FeetishBannerViewModel: ObservableObject, FeetishBannerBased {
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
        
        timerForNotification = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] timer in
            guard let strongSelf = self else {
                return
            }
            
            guard let _ = strongSelf.model else {
                // make sure we at least have a model :)
                return
            }
            
            if strongSelf.isBeingDragged {
                return
            }
            
            strongSelf.currentBannerTime = strongSelf.currentBannerTime + 1
            
            if strongSelf.currentBannerTime == 4 {
                strongSelf.timerForNotification?.invalidate()
                strongSelf.timerForNotification = nil
                
                print("REMOVE ALL")
                
                strongSelf.removeCurrentBanner()
                
                return
            }
        })
    }
}
