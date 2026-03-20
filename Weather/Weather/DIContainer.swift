//
//  DIContainer.swift
//  Weather
//
//  Created by Maxim on 19.03.2026.
//

import UIKit

class DIContainer {
    func makeWeatherCoordinator(router: UINavigationController) -> WeatherCoordinator {
        return WeatherCoordinator(router: router, container: self)
    }
}
