//
//  Weather.swift
//  Weather
//
//  Created by Maxim on 18.03.2026.
//

import Foundation

struct Weather: Equatable {
    let locationName: String
    let current: CurrentWeather
    let hourlyForecast: [HourlyWeather]
    let dailyForecast: [DailyWeather]
    let lastUpdated: String
}
