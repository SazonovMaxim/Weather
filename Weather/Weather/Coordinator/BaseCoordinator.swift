//
//  BaseCoordinator.swift
//  Weather
//
//  Created by Maxim on 19.03.2026.
//

import Combine
import Foundation
class BaseCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    
    var cancellables = Set<AnyCancellable>()
        
    let didFinish = PassthroughSubject<BaseCoordinator, Never>()
    
    func start() {
        
    }
    
    func finish() {
        didFinish.send(self)
    }
}

extension BaseCoordinator {
    func addDependedCoordinator(_ coordinator: Coordinator) {
        for element in childCoordinators {
            if element === coordinator { return }
        }
        childCoordinators.append(coordinator)
    }
    
    func removeDependedCoordinator(_ coordinator: Coordinator) {
        guard
            childCoordinators.isEmpty == false
        else { return }
        
        for (index, element) in childCoordinators.enumerated() {
            if element === coordinator {
                childCoordinators.remove(at: index)
                return
            }
        }
    }
    
}
