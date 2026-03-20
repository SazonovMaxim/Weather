//
//  WeatherCoordinator.swift
//  Weather
//
//  Created by Maxim on 19.03.2026.
//

import UIKit

class WeatherCoordinator: BaseCoordinator {
    private let container: DIContainer
    private let router: UINavigationController
    private let locationService: LocationServiceProtocol
    private let weatherService: WeatherAPIServiceProtocol
    
    init(router: UINavigationController, container: DIContainer,
         locationService: LocationServiceProtocol = LocationService(),
         weatherService: WeatherAPIServiceProtocol = WeatherAPIService()) {
        self.router = router
        self.container = container
        self.locationService = locationService
        self.weatherService = weatherService
    }
    
    override func start() {
        let viewModel = WeatherViewModel(
            locationService: locationService,
            weatherService: weatherService
        )
        let viewController = WeatherViewController(viewModel: viewModel)
        
        router.setViewControllers([viewController], animated: false)
    }
}
