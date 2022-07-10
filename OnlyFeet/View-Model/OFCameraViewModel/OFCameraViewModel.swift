//
//  OFCameraViewModel.swift
//  OnlyFeet
//
//  Created by Fuad on 07/07/2022.
//

import CoreImage
import UIKit.UIImage

protocol OFCameraVMBased {
    func focus(_ focusPoint: CGPoint)
    func changePosition()
    func takePhoto()
    func savePhoto()
    func set(cameraPurpose: OFCameraPurpose)
    func removeTakenPhoto()
}

class OFCameraViewModel: ObservableObject {
    @Published var frame: CGImage?
    @Published var error: Error?
    @Published var takenPhoto: CGImage?
    @Published var cameraPurpose: OFCameraPurpose = .none
    @Published var savedPhoto: UIImage?
    
    private let cameraManager = OFCameraManager.shared
    
    private let frameManager = OFCameraFrameManager.shared
    
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
}

extension OFCameraViewModel: OFCameraVMBased {
    func focus(_ focusPoint: CGPoint) {
        cameraManager.focus(on: focusPoint)
    }
    
    func changePosition() {
        cameraManager.changePosition()
    }
    
    func takePhoto() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(55)) {
            self.takenPhoto = self.frame
        }
    }
    
    func savePhoto() {
        guard let takenPhoto = self.takenPhoto else {
            return
        }
         
        self.savedPhoto = UIImage(cgImage: takenPhoto)
        
        self.removeTakenPhoto()
    }
    
    func set(cameraPurpose: OFCameraPurpose) {
        self.cameraPurpose = cameraPurpose
    }
    
    func removeTakenPhoto() {
        self.takenPhoto = nil
    }
}
