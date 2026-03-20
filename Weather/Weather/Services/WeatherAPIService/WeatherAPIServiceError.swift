//
//  WeatherAPIServiceError.swift
//  Weather
//
//  Created by Maxim on 18.03.2026.
//

import Foundation

enum WeatherAPIServiceError: LocalizedError {
    
    case invalidBaseURL
    case invalidResponse
    case requestFailed(statusCode: Int, message: String?)

    var errorDescription: String? {
        switch self {
        case .invalidBaseURL:
            return "Weather API base URL is invalid."
        case .invalidResponse:
            return "Weather API returned an invalid response."
        case .requestFailed(let statusCode, let message):
            if let message, !message.isEmpty {
                return "Weather API request failed (\(statusCode)): \(message)"
            }
            return "Weather API request failed with status code \(statusCode)."
        }
    }
}


