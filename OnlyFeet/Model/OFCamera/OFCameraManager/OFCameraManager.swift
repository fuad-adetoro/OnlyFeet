//
//  OFCameraManager.swift
//  OnlyFeet
//
//  Created by Fuad on 07/07/2022.
//

import AVFoundation

class OFCameraManager: ObservableObject {
    @Published var error: OFCameraError?
    
    let session = AVCaptureSession()
    
    private let sessionQueue = DispatchQueue(label: "app.feetish.sessionQ")
    
    private let videoOutput = AVCaptureVideoDataOutput()
    
    private var status = Status.unconfigured
    
    private var device: AVCaptureDevice? = nil
    
    enum Status {
        case unconfigured
        case configured
        case unauthorized
        case failed
    }
    
    static let shared = OFCameraManager()
    
    private init() {
        configure()
    }
    
    private func configure() {
        checkPermissions()
        
        sessionQueue.async {
            self.configureCaptureSession()
            self.session.startRunning()
        }
    }
    
    func focus(on focusPoint: CGPoint) {
        if let device = self.device {
            do {
                try device.lockForConfiguration()
                if device.isFocusPointOfInterestSupported {
                    device.focusPointOfInterest = focusPoint
                    device.focusMode = AVCaptureDevice.FocusMode.autoFocus
                }
                if device.isExposurePointOfInterestSupported {
                    device.exposurePointOfInterest = focusPoint
                    device.exposureMode = AVCaptureDevice.ExposureMode.autoExpose //AVCaptureExposureMode.autoExpose
                }
                device.unlockForConfiguration()
            } catch {
                self.error = .zoomFocusError
                return
            }
        }
    }
    
    func changePosition() {
        //Remove existing input
        guard let currentCameraInput: AVCaptureInput = session.inputs.first else {
            return
        }
        
        //Indicate that some changes will be made to the session
        session.beginConfiguration()
        session.removeInput(currentCameraInput)
        
        //Get new input
        var newCamera: AVCaptureDevice! = nil
        if let input = currentCameraInput as? AVCaptureDeviceInput {
            if (input.device.position == .back) {
                newCamera = cameraWithPosition(position: .front)
            } else {
                newCamera = cameraWithPosition(position: .back)
            }
        }
        
        //Add input to session
        var err: NSError?
        var newVideoInput: AVCaptureDeviceInput!
        do {
            newVideoInput = try AVCaptureDeviceInput(device: newCamera)
        } catch let err1 as NSError {
            err = err1
            newVideoInput = nil
        }
        
        if newVideoInput == nil || err != nil {
            print("Error creating capture device input: \(err?.localizedDescription)")
        } else {
            session.addInput(newVideoInput)
        }
        
        //Commit all the configuration changes at once
        session.commitConfiguration()
    }
    
    private func cameraWithPosition(position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .unspecified)
        for device in discoverySession.devices {
            if device.position == position {
                return device
            }
        }
        
        return nil
    }
    
    private func set(error: OFCameraError?) {
        DispatchQueue.main.async {
            self.error = error
        }
    }
    
    // Using this method, your upcoming frame manager will be able to set itself as the delegate that receives that camera data.
    func set(_ delegate: AVCaptureVideoDataOutputSampleBufferDelegate, queue: DispatchQueue) {
        sessionQueue.async {
            self.videoOutput.setSampleBufferDelegate(delegate, queue: queue)
        }
    }
    
    func checkPermissions() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined:
            sessionQueue.suspend()
            
            AVCaptureDevice.requestAccess(for: .video) { authorized in
                if !authorized {
                    self.status = .unauthorized
                    self.set(error: .deniedAuthorization)
                }
                
                self.sessionQueue.resume()
            }
        case .restricted:
            status = .unauthorized
            self.set(error: .restrictedAuthorization)
        case .denied:
            status = .unauthorized
            self.set(error: .deniedAuthorization)
        case .authorized:
            break
        @unknown default:
            status = .unauthorized
            self.set(error: .unknownAuthorization)
        }
    }
    
    private func configureCaptureSession() {
        guard status == .unconfigured else {
            return
        }
        
        session.beginConfiguration()
        
        do {
            session.commitConfiguration()
        }
        
        device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
        
        guard let camera = device else {
            self.set(error: .cameraUnavailable)
            
            status = .failed
            
            return
        }
        
        do {
            let cameraInput = try AVCaptureDeviceInput(device: camera)
            
            if session.canAddInput(cameraInput) {
                session.addInput(cameraInput)
            } else {
                self.set(error: .cannotAddInput)
                status = .failed
                return
            }
        } catch {
            self.set(error: .createCaptureInput(error))
            status = .failed
            return
        }
        
        if session.canAddOutput(videoOutput) {
            session.addOutput(videoOutput)
            
            videoOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA]
            
            let videoConnection = videoOutput.connection(with: .video)
            
            videoConnection?.videoOrientation = .portrait
        } else {
            self.set(error: .cannotAddOutput)
            status = .failed
            return
        }
        
        status = .configured
    }
}
