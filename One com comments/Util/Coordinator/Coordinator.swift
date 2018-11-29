//
//  Coordinator.swift
//  Perfect Space
//
//  Created by Mihail Stevcev on 6/20/18.
//  Copyright © 2018 Perfect Space. All rights reserved.
//

import Foundation

protocol CoordinatorDelegate: class{
    func coordinatorDidFinish(coordinator: Coordinator)
}

protocol Coordinator: class {
    var childCoordinators: [Coordinator] { get set }
    var delegate: CoordinatorDelegate? { get set }
    func start() -> Void
}

extension Coordinator {
    /// Add a child coordinator to the parent
    func addChildCoordinator(_ coordinator: Coordinator) {
        self.childCoordinators.append(coordinator)
    }
    
    /// Remove a child coordinator from the parent
    func removeChildCoordinator(_ coordinator: Coordinator) {
        self.childCoordinators = self.childCoordinators.filter { $0 !== coordinator }
    }
}
