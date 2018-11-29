//
//  ApplicationFlowCoordinator.swift
//  Zest
//
//  Created by Mihail Stevcev on 8/20/18.
//  Copyright © 2018 Bombay Sour. All rights reserved.
//

import UIKit


class ApplicationFlowCoordinator: Coordinator, CoordinatorDelegate, LoginViewControllerDelegate {
 
    var childCoordinators: [Coordinator] = []
    var delegate: CoordinatorDelegate?
    
    var window: UIWindow

    
    private var rootViewController: UINavigationController = UINavigationController()
    
    // This is stored here for simplicoty, view controller factory pattern solves this
    private var repository = CommentsRepositoryFirebase()
    
    
    //MARK: Initializer
    
    init(window: UIWindow) {
        self.window = window
    }
    
    //MARK: Coordinator
    
    func start() {
        self.rootViewController.setNavigationBarHidden(true, animated: false)
        
        self.window.rootViewController = self.rootViewController
        
        let presenter = LoginViewPresenter(repository: self.repository)
        let loginViewController = LoginViewController(presenter: presenter)
        loginViewController.delegate = self
        self.rootViewController.setViewControllers([loginViewController], animated: false)
    }
    
    //MARK: Coordinator delegate
    
    func coordinatorDidFinish(coordinator: Coordinator) {
        
    }
    
    //MARK: LoginViewController
    
    func loginView(controller: LoginViewController, didLoginWith user: User) {
        let presenter = CommentsFeedPresenter(repository: self.repository, user: user)
        let commentsFeedController = CommentsFeedViewController(presenter: presenter)
        self.rootViewController.setViewControllers([commentsFeedController], animated: true)
    }
 
}
