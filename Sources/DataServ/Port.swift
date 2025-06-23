//
//  Port.swift
//  DataServ
//
//  Specification:
//  • Publisher/subscriber conduit for streaming values of type T.
//  • Built atop Combine’s PassthroughSubject.
//
//  Discussion:
//  Ports model Rep update channels and event streams.
//  Subscribers listen for new data or Rep mutation events.
//
//  Rationale:
//  • Combine is first-class in Swift 6.2.
//  • PassthroughSubject ensures non-blocking streams.
//
//  Dependencies: Combine
//  Created by Thomas Wahl on 06/22/2025.
//  © 2025 Cognautics. All rights reserved.
//

import Foundation
import Combine

public class Port<T> {
    private let subject = PassthroughSubject<T, Never>()

    /// Publish a new value to all subscribers.
    public func send(_ value: T) {
        subject.send(value)
    }

    /// AnyPublisher to subscribe to updates.
    public func publisher() -> AnyPublisher<T, Never> {
        subject.eraseToAnyPublisher()
    }
}
