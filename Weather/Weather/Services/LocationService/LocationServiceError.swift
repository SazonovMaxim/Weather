//
//  LocationServiceError.swift
//  Weather
//
//  Created by Maxim on 18.03.2026.
//

import Foundation

enum LocationServiceError: LocalizedError {
    case servicesDisabled
    case accessDenied
    case authorizationRestricted
    case failedToResolveLocation
    case requestInProgress

    var errorDescription: String? {
        switch self {
        case .servicesDisabled:
            return "Location services are disabled on this device."
        case .accessDenied:
            return "Allow location access to load the weather for your current position."
        case .authorizationRestricted:
            return "Location access is restricted."
        case .failedToResolveLocation:
            return "Unable to determine the current location."
        case .requestInProgress:
            return "A location request is already in progress."
        }
    }
}
