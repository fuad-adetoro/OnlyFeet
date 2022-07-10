//
//  FeetishSubject.swift
//  OnlyFeet
//
//  Created by Fuad on 10/07/2022.
//

import Combine

struct FeetishSubject<Element, CustomError: Error>: Publisher {
    typealias Output = Element
    typealias Failure = CustomError
    
    let publisher = PassthroughSubject<Output, Failure>()
    
    func receive<S>(subscriber: S) where S : Subscriber, CustomError == S.Failure, Element == S.Input {
        publisher.receive(subscriber: subscriber)
    }
}
