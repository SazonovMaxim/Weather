//
//  WeatherDashboardData.swift
//  Weather
//
//  Created by Maxim on 18.03.2026.
//

import Foundation

struct WeatherDashboardViewData {
    let current: CurrentWeatherCellViewData
    let hourlySectionTitle: String
    let hourlyItems: [HourlyForecastCellViewData]
    let dailySectionTitle: String
    let dailyItems: [DailyForecastCellViewData]

    static let empty = WeatherDashboardViewData(
        current: CurrentWeatherCellViewData(
            cityText: "Загрузка...",
            temperatureText: "--",
            conditionText: "Ожидание данных",
            summaryText: "Как только координаты или fallback-город будут определены, здесь появятся текущие данные.",
            statusText: nil,
            statusIsError: false,
            isLoading: false
        ),
        hourlySectionTitle: "Почасовая погода",
        hourlyItems: [],
        dailySectionTitle: "Прогноз на 3 дня",
        dailyItems: []
    )
}


struct CurrentWeatherCellViewData {
    let cityText: String
    let temperatureText: String
    let conditionText: String
    let summaryText: String
    let statusText: String?
    let statusIsError: Bool
    let isLoading: Bool
}

struct HourlyForecastCellViewData {
    let hourText: String
    let conditionText: String
    let temperatureText: String
}

struct DailyForecastCellViewData {
    let dayText: String
    let conditionText: String
    let temperatureText: String
}
