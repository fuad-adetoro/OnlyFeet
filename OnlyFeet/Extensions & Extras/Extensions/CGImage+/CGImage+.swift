//
//  CGImage+.swift
//  OnlyFeet
//
//  Created by Fuad on 07/07/2022.
//

import CoreGraphics
import VideoToolbox

extension CGImage {
    // Converting CVPixelBuffer to a CGImage!
  static func create(from cvPixelBuffer: CVPixelBuffer?) -> CGImage? {
    guard let pixelBuffer = cvPixelBuffer else {
      return nil
    }

    var image: CGImage?
    VTCreateCGImageFromCVPixelBuffer(
      pixelBuffer,
      options: nil,
      imageOut: &image)
    return image
  }
}
