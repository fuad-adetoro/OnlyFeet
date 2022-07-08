//
//  OFCameraViewModel.swift
//  OnlyFeet
//
//  Created by Fuad on 07/07/2022.
//

import CoreImage

protocol OFCameraVMBased {
    func setupSubscriptions()
    func focus(_ focusPoint: CGPoint)
    func changePosition()
}

class OFCameraViewModel: ObservableObject, OFCameraVMBased {
    @Published var frame: CGImage?
    @Published var error: Error?
    
    private let cameraManager = OFCameraManager.shared
    
    private let frameManager = OFCameraFrameManager.shared
    
    var cameraPurpose: OFCameraPurpose = .none
    
    init() {
        setupSubscriptions()
    }
    
    func setupSubscriptions() {
        cameraManager.$error
            .receive(on: RunLoop.main)
            .map { $0 }
            .assign(to: &$error)
        
        frameManager.$current
            .receive(on: RunLoop.main)
            .compactMap { buffer in
                return CGImage.create(from: buffer)
            }
            .assign(to: &$frame)
    }
    
    func focus(_ focusPoint: CGPoint) {
        cameraManager.focus(on: focusPoint)
    }
    
    func changePosition() {
        cameraManager.changePosition()
    }
}
