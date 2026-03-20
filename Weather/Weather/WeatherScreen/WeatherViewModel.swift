//
//  WeatherViewModel.swift
//  Weather
//
//  Created by Maxim on 18.03.2026.
//

import Foundation

enum WeatherViewState {
    case idle(WeatherDashboardViewData)
    case loading(WeatherDashboardViewData)
    case loaded(WeatherDashboardViewData)
    case failed(WeatherDashboardViewData, alertMessage: String)
}

final class WeatherViewModel {
    private let fallbackCoordinate = LocationCoordinate(
        latitude: 55.7558,
        longitude: 37.6176
    )

    var onStateChange: ((WeatherViewState) -> Void)?

    private let locationService: LocationServiceProtocol
    private let weatherService: WeatherAPIServiceProtocol
    private var latestWeather: Weather?

    private lazy var hourFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "HH:mm"
        return formatter
    }()

    private lazy var dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "E, d MMM"
        return formatter
    }()

    init(
        locationService: LocationServiceProtocol,
        weatherService: WeatherAPIServiceProtocol
    ) {
        self.locationService = locationService
        self.weatherService = weatherService
    }

    func requestWeather() {
        onStateChange?(.loading(makeViewData(weather: latestWeather, statusText: "Загружаю текущую погоду и прогноз...", isLoading: true)))

        Task { [weak self] in
            guard let self else { return }

            do {
                let coordinate = try await self.locationService.requestCurrentLocation()
                do {
                    try await self.loadWeather(for: coordinate)
                } catch {
                    self.emitFailureState(
                        for: error,
                        statusText: error.localizedDescription
                    )
                }
            } catch {
                let fallbackStatusText = "\(error.localizedDescription) Показываю погоду для Москвы."
                self.emitFailureState(
                    for: error,
                    statusText: fallbackStatusText
                )

                do {
                    try await self.loadWeather(for: self.fallbackCoordinate)
                } catch {
                    self.emitFailureState(
                        for: error,
                        statusText: error.localizedDescription
                    )
                }
            }
        }
    }

    private func loadWeather(for coordinate: LocationCoordinate) async throws {
        let weather = try await weatherService.fetchWeather(
            latitude: coordinate.latitude,
            longitude: coordinate.longitude
        )
        latestWeather = weather
        onStateChange?(.loaded(makeViewData(weather: weather, statusText: "Обновлено: \(weather.lastUpdated)")))
    }

    
    
    private func emitFailureState(
        for error: Error,
        statusText: String
    ) {
        onStateChange?(
            .failed(
                makeViewData(
                    weather: latestWeather,
                    statusText: statusText,
                    isStatusError: true
                ),
                alertMessage: error.localizedDescription
            )
        )
    }

    private func makeViewData(
        weather: Weather?,
        statusText: String? = nil,
        isStatusError: Bool = false,
        isLoading: Bool = false
    ) -> WeatherDashboardViewData {
        guard let weather else {
            return WeatherDashboardViewData(
                current: CurrentWeatherCellViewData(
                    cityText: "Загрузка...",
                    temperatureText: "--",
                    conditionText: "Ожидание данных",
                    summaryText: "Как только координаты или fallback-город будут определены, здесь появятся текущие данные.",
                    statusText: statusText,
                    statusIsError: isStatusError,
                    isLoading: isLoading
                ),
                hourlySectionTitle: "Почасовая погода",
                hourlyItems: [],
                dailySectionTitle: "Прогноз на 3 дня",
                dailyItems: []
            )
        }

        let hourlyItems = weather.hourlyForecast.map {
            HourlyForecastCellViewData(
                hourText: hourFormatter.string(from: $0.time),
                conditionText: $0.condition,
                temperatureText: "\(Int($0.temperatureC.rounded()))°"
            )
        }

        let dailyItems = weather.dailyForecast.map {
            DailyForecastCellViewData(
                dayText: dayFormatter.string(from: $0.date).capitalized,
                conditionText: $0.condition,
                temperatureText: "\(Int($0.minimumTemperatureC.rounded()))° / \(Int($0.maximumTemperatureC.rounded()))°"
            )
        }

        return WeatherDashboardViewData(
            current: CurrentWeatherCellViewData(
                cityText: weather.locationName,
                temperatureText: "\(Int(weather.current.temperatureC.rounded()))°",
                conditionText: weather.current.condition,
                summaryText: "Ощущается как \(Int(weather.current.feelsLikeC.rounded()))°. Ветер \(Int(weather.current.windKph.rounded())) км/ч. Влажность \(weather.current.humidity)%.",
                statusText: statusText,
                statusIsError: isStatusError,
                isLoading: isLoading
            ),
            hourlySectionTitle: "Почасовая погода",
            hourlyItems: hourlyItems,
            dailySectionTitle: "Прогноз на 3 дня",
            dailyItems: dailyItems
        )
    }
}
