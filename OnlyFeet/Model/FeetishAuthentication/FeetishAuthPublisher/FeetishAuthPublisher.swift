//
//  FeetishAuthPublisher.swift
//  OnlyFeet
//
//  Created by Fuad on 22/06/2022.
//
 
import Combine

struct FeetishAuthPublisher<Element>: Publisher {
    typealias Output = Element
    typealias Failure = FeetishAuthError
    
    let publisher = PassthroughSubject<Output, Failure>()
    
    func receive<S>(subscriber: S) where S : Subscriber, FeetishAuthError == S.Failure, Element == S.Input {
        publisher.receive(subscriber: subscriber)
    }
}
