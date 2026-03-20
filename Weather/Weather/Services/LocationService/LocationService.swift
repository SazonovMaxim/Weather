//
//  LocationService.swift
//  Weather
//
//  Created by Maxim on 18.03.2026.
//

import CoreLocation
import Foundation


protocol LocationServiceProtocol: AnyObject {
    var authorizationStatus: CLAuthorizationStatus { get }

    func requestCurrentLocation() async throws -> LocationCoordinate
}

final class LocationService: NSObject, LocationServiceProtocol {

    private let locationManager: CLLocationManager
    private var locationContinuation: CheckedContinuation<LocationCoordinate, Error>?
    private var authorizationContinuation: CheckedContinuation<Void, Error>?
    
    var authorizationStatus: CLAuthorizationStatus {
        locationManager.authorizationStatus
    }
    
    init(locationManager: CLLocationManager = CLLocationManager()) {
        self.locationManager = locationManager
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
    }
    
    func requestCurrentLocation() async throws -> LocationCoordinate {
        guard CLLocationManager.locationServicesEnabled() else {
            throw LocationServiceError.servicesDisabled
        }
        
        guard locationContinuation == nil else {
            throw LocationServiceError.requestInProgress
        }
        
        switch authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            return try await withCheckedThrowingContinuation { continuation in
                locationContinuation = continuation
                locationManager.requestLocation()
            }
        case .notDetermined:
            try await requestAuthorizationIfNeeded()
            return try await requestCurrentLocation()
        case .denied:
            throw LocationServiceError.accessDenied
        case .restricted:
            throw LocationServiceError.authorizationRestricted
        @unknown default:
            throw LocationServiceError.failedToResolveLocation
        }
    }
    
    private func requestAuthorizationIfNeeded() async throws {
        guard authorizationStatus == .notDetermined else { return }
        
        try await withCheckedThrowingContinuation { continuation in
            authorizationContinuation = continuation
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    private func finishLocationRequest(with result: Result<LocationCoordinate, Error>) {
        guard let continuation = locationContinuation else { return }
        locationContinuation = nil
        continuation.resume(with: result)
    }

    private func finishAuthorizationRequest(with result: Result<Void, Error>) {
        guard let continuation = authorizationContinuation else { return }
        authorizationContinuation = nil
        continuation.resume(with: result)
    }
}


extension LocationService: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        Task { @MainActor in
            switch manager.authorizationStatus {
            case .authorizedAlways, .authorizedWhenInUse:
                finishAuthorizationRequest(with: .success(()))
            case .denied:
                finishAuthorizationRequest(with: .failure(LocationServiceError.accessDenied))
            case .restricted:
                finishAuthorizationRequest(with: .failure(LocationServiceError.authorizationRestricted))
            case .notDetermined:
                break
            @unknown default:
                finishAuthorizationRequest(with: .failure(LocationServiceError.failedToResolveLocation))
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        Task { @MainActor in
            guard let location = locations.last else {
                finishLocationRequest(with: .failure(LocationServiceError.failedToResolveLocation))
                return
            }

            let coordinate = LocationCoordinate(
                latitude: location.coordinate.latitude,
                longitude: location.coordinate.longitude
            )
            finishLocationRequest(with: .success(coordinate))
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        Task { @MainActor in
            finishLocationRequest(with: .failure(error))
        }
    }
}
