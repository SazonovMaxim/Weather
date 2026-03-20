//
//  CurrentWeather.swift
//  Weather
//
//  Created by Maxim on 18.03.2026.
//

import Foundation

struct CurrentWeather: Equatable {
    let temperatureC: Double
    let feelsLikeC: Double
    let condition: String
    let windKph: Double
    let humidity: Int
}
