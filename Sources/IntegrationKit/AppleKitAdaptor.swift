//
//  AppleKitAdaptor.swift
//  ToolExp
//
//  Created by Thomas Wahl on 6/16/25.
//

//
// AppleKitAdaptor.swift
// IntegrationKit — Adapts Apple frameworks (WeatherKit, CoreLocation).
//
// NEVER use JSON.  All data comes via system frameworks.
//

import Foundation
import WeatherKit
import CoreLocation

/// Provides weather lookups via Apple’s WeatherKit.
public actor AppleKitAdaptor {
    private let weatherService = WeatherService.shared
    private let geocoder = CLGeocoder()

    public init() {}

    /// Fetches current weather for a human-readable address.
    ///
    /// - Parameter address: e.g. "San Francisco, CA".
    /// - Returns: the `CurrentWeather` from WeatherKit.
    public func fetchCurrentWeather(for address: String) async throws -> CurrentWeather {
        // 1. Geocode the address to lat/long
        let placemarks = try await geocoder.geocodeAddressString(address)
        guard let location = placemarks.first?.location else {
            throw NSError(domain: "AppleKitAdaptor", code: 1, userInfo: [
                NSLocalizedDescriptionKey: "Unable to geocode address"
            ])
        }
        // 2. Query WeatherKit
        let weather = try await weatherService.weather(for: location)
        return weather.currentWeather
    }
}
