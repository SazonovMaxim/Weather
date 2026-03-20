//
//  WeatherAPIForecastResponse.swift
//  Weather
//
//  Created by Maxim on 18.03.2026.
//

import Foundation

struct WeatherForecastResponse: Decodable {
    let location: LocationData
    let current: WeatherCurrentData
    let forecast: WeatherForecastData
    
    var asWeather: Weather {
        let currentHour = current.lastUpdatedDate.roundedDownToHour
        let nextDaySameHour = Calendar.current.date(byAdding: .day, value: 1, to: currentHour) ?? currentHour
        let hourlyForecast = forecast.forecastday
            .flatMap(\.hour)
            .filter { $0.time >= currentHour && $0.time <= nextDaySameHour }
            .map(\.asHourlyWeather)

        return Weather(
            locationName: "\(location.name), \(location.country)",
            current: CurrentWeather(
                temperatureC: current.tempC,
                feelsLikeC: current.feelslikeC,
                condition: current.condition.text,
                windKph: current.windKph,
                humidity: current.humidity
            ),
            hourlyForecast: hourlyForecast,
            dailyForecast: forecast.forecastday.prefix(3).map(\.asDailyWeather),
            lastUpdated: current.lastUpdated
        )
    }
}

extension WeatherForecastResponse {
    struct LocationData: Decodable {
        let name: String
        let country: String
    }
    
    struct WeatherCurrentData: Decodable {
        let tempC: Double
        let feelslikeC: Double
        let windKph: Double
        let humidity: Int
        let lastUpdated: String
        let condition: ConditionData

        var lastUpdatedDate: Date {
            Self.dateFormatter.date(from: lastUpdated) ?? .now
        }

        private static let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            return formatter
        }()

        enum CodingKeys: String, CodingKey {
            case tempC = "temp_c"
            case feelslikeC = "feelslike_c"
            case windKph = "wind_kph"
            case humidity
            case lastUpdated = "last_updated"
            case condition
        }
    }
    
    struct WeatherForecastData: Decodable {
        let forecastday: [ForecastDayData]
    }
    
    
}

extension WeatherForecastResponse {
    struct ConditionData: Decodable {
        let text: String
    }

    struct ForecastDayData: Decodable {
        let date: String
        let day: DayData
        let hour: [HourData]

        var asDailyWeather: DailyWeather {
            DailyWeather(
                date: Self.dateFormatter.date(from: date) ?? .now,
                minimumTemperatureC: day.mintempC,
                maximumTemperatureC: day.maxtempC,
                condition: day.condition.text
            )
        }

        private static let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.dateFormat = "yyyy-MM-dd"
            return formatter
        }()
    }

    struct DayData: Decodable {
        let maxtempC: Double
        let mintempC: Double
        let condition: ConditionData

        enum CodingKeys: String, CodingKey {
            case maxtempC = "maxtemp_c"
            case mintempC = "mintemp_c"
            case condition
        }
    }

    struct HourData: Decodable {
        let timeEpoch: Int
        let tempC: Double
        let condition: ConditionData

        var time: Date {
            Date(timeIntervalSince1970: TimeInterval(timeEpoch))
        }

        var asHourlyWeather: HourlyWeather {
            HourlyWeather(
                time: time,
                temperatureC: tempC,
                condition: condition.text
            )
        }

        enum CodingKeys: String, CodingKey {
            case timeEpoch = "time_epoch"
            case tempC = "temp_c"
            case condition
        }
    }
}
