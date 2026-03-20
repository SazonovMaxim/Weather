//
//  WeatherAPIErrorResponse.swift
//  Weather
//
//  Created by Maxim on 18.03.2026.
//

import Foundation

struct WeatherAPIErrorResponse: Decodable {
    let error: WeatherAPIErrorData
}

struct WeatherAPIErrorData: Decodable {
    let code: Int
    let message: String
}
