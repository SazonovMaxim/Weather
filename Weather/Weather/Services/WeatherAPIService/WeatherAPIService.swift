//
//  WeatherAPIService.swift
//  Weather
//
//  Created by Maxim on 18.03.2026.
//

import Foundation

protocol WeatherAPIServiceProtocol: AnyObject {
    func fetchWeather(
        latitude: Double,
        longitude: Double
    ) async throws -> Weather
}

final class WeatherAPIService: WeatherAPIServiceProtocol {
    private enum Constants {
        static let baseURLString = "http://api.weatherapi.com/v1"
        static let apiKey = "150ea732894b415ca41124444261803"
        static let forecastDayCount = 3
    }
    
    private let apiKey: String = Constants.apiKey
    private let forecastDayString: String = "\(Constants.forecastDayCount)"
    
    private let session: URLSession
    private let decoder: JSONDecoder
    private let baseURL: URL?
    
    
    init(
        session: URLSession = .shared,
        decoder: JSONDecoder = JSONDecoder(),
        baseURLString: String = Constants.baseURLString
    ) {
        self.session = session
        self.decoder = decoder
        self.baseURL = URL(string: baseURLString)
    }
    
    func fetchWeather(latitude: Double, longitude: Double) async throws -> Weather {
        guard let baseURL else {
            throw WeatherAPIServiceError.invalidBaseURL
        }
        
        guard var components = URLComponents(url: baseURL.appendingPathComponent("forecast.json"), resolvingAgainstBaseURL: false) else {
            throw WeatherAPIServiceError.invalidBaseURL
        }
        
        components.queryItems = [
            URLQueryItem(name: "key", value: apiKey),
            URLQueryItem(name: "q", value: "\(latitude),\(longitude)"),
            URLQueryItem(name: "days", value: forecastDayString),
            URLQueryItem(name: "aqi", value: "no"),
            URLQueryItem(name: "alerts", value: "no")
        ]
        
        guard let url = components.url else {
            throw WeatherAPIServiceError.invalidBaseURL
        }
        
        let (data, response) = try await session.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw WeatherAPIServiceError.invalidResponse
        }

        guard (200..<300).contains(httpResponse.statusCode) else {
            let apiError = try? decoder.decode(WeatherAPIErrorResponse.self, from: data)
            
            throw WeatherAPIServiceError.requestFailed(
                statusCode: httpResponse.statusCode,
                message: apiError?.error.message
            )
        }

        let weatherResponse = try decoder.decode(WeatherForecastResponse.self, from: data)
        return weatherResponse.asWeather
    }
}
