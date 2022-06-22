//
//  FeetishBannerData.swift
//  OnlyFeet
//
//  Created by Fuad on 22/06/2022.
//

import SwiftUI

public struct FeetishBannerData: Identifiable {
    public let id = UUID()
    public let title: String?
    public let message: String?
    public let bannerError: Error?
}
