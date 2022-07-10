//
//  OFCameraClickableBackground.swift
//  OnlyFeet
//
//  Created by Fuad on 07/07/2022.
//

import SwiftUI

struct OFCameraClickableBackground: UIViewRepresentable {
    var tappedCallback: ((CGPoint) -> Void)
    var doubleTapCallback: (() -> Void)

    func makeUIView(context: UIViewRepresentableContext<OFCameraClickableBackground>) -> UIView {
        let v = UIView(frame: .zero)
        let gesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.tapped))
        let doubleTapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.doubleTapped))
        doubleTapGesture.numberOfTapsRequired = 2
        v.addGestureRecognizer(gesture)
        v.addGestureRecognizer(doubleTapGesture)
        return v
    }

    class Coordinator: NSObject {
        var tappedCallback: ((CGPoint) -> Void)
        var doubleTapCallback: (() -> Void)
        init(tappedCallback: @escaping ((CGPoint) -> Void), doubleTapCallback: @escaping (() -> Void)) {
            self.tappedCallback = tappedCallback
            self.doubleTapCallback = doubleTapCallback
        }
        @objc func tapped(gesture:UITapGestureRecognizer) {
            let point = gesture.location(in: gesture.view)
            self.tappedCallback(point)
        }
        @objc func doubleTapped(gesture:UITapGestureRecognizer) {
            let _ = gesture.location(in: gesture.view)
            self.doubleTapCallback()
        }
    }

    func makeCoordinator() -> OFCameraClickableBackground.Coordinator {
        return Coordinator(tappedCallback:self.tappedCallback, doubleTapCallback: self.doubleTapCallback)
    }

    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<OFCameraClickableBackground>) {
    }
} 
