//
//  OFCameraFrameManager.swift
//  OnlyFeet
//
//  Created by Fuad on 07/07/2022.
//

import AVFoundation

class OFCameraFrameManager: NSObject, ObservableObject {
    static let shared = OFCameraFrameManager()
    
    @Published var current: CVPixelBuffer?
    
    let videoOutputQueue = DispatchQueue(label: "app.feetish.VideoOutputQ", qos: .userInitiated, attributes: [], autoreleaseFrequency: .workItem)
    
    private override init() {
        super.init()
        
        OFCameraManager.shared.set(self, queue: videoOutputQueue)
    }
}

extension OFCameraFrameManager: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        if let buffer = sampleBuffer.imageBuffer {
            connection.videoOrientation = .portrait
            
            DispatchQueue.main.async {
                self.current = buffer 
            }
        }
    }
}
