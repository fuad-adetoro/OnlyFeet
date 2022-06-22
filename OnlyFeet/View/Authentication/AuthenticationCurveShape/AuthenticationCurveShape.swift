//
//  AuthenticationCurveShape.swift
//  OnlyFeet
//
//  Created by Fuad on 21/06/2022.
//

import Foundation
import SwiftUI 

struct AuthenticationCurveShapeOne : Shape {
    func path(in rect: CGRect) -> Path {
        return Path{path in
            path.move(to: CGPoint(x: rect.width, y: 100))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: 0, y: rect.height))
            path.addLine(to: CGPoint(x: 0, y: 0))
        }
    }
}


struct AuthenticationCurveShapeTwo : Shape {
    func path(in rect: CGRect) -> Path {
        return Path{ path in
            path.move(to: CGPoint(x: 0, y: 100))
            path.addLine(to: CGPoint(x: 0, y: rect.height))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: rect.width, y: 0))
        }
    }
}
