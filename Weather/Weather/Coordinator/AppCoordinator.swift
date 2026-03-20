//
//  AppCoordinator.swift
//  Weather
//
//  Created by Maxim on 19.03.2026.
//

import UIKit

final class AppCoordinator: BaseCoordinator {
    private let window: UIWindow
    
    var navigationController: UINavigationController
    
    private let container: DIContainer
    
    init(window: UIWindow, container: DIContainer) {
        self.window = window
        self.container = container
        self.navigationController = UINavigationController()
        
        super.init()
    }
    
    override func start() {
        runWeatherFlow()
    }
}

extension AppCoordinator {
    private func runWeatherFlow() {
        let weatherCoordinator = self.container.makeWeatherCoordinator(router: navigationController)
        
        addDependedCoordinator(weatherCoordinator)
        
        weatherCoordinator.start()
        
        self.window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}
