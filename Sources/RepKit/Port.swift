//
//  Port.swift
//  RepKit
//
//  Specification:
//  • Publisher/subscriber conduit for RepGraph updates.
//  • Built on Combine’s PassthroughSubject.
//
//  Discussion:
//  Systems consume Rep update streams to redraw or re-evaluate.
//
//  Rationale:
//  • Leverage Combine for reactive programming.
//  Dependencies: Combine
//  Created by Thomas Wahl on 06/22/2025.
//  © 2025 Cognautics. All rights reserved.
//

import Combine

public class Port<T> {
    private let subject = PassthroughSubject<T, Never>()
    public func send(_ value: T) { subject.send(value) }
    public func publisher() -> AnyPublisher<T, Never> { subject.eraseToAnyPublisher() }
}
