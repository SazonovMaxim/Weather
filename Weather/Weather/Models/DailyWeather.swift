//
//  DailyWeather.swift
//  Weather
//
//  Created by Maxim on 18.03.2026.
//

import Foundation

struct DailyWeather: Equatable {
    let date: Date
    let minimumTemperatureC: Double
    let maximumTemperatureC: Double
    let condition: String
}
