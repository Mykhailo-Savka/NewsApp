//
//  AppRouter.swift
//  NewsApp
//
//  Created by Savka Mykhailo on 18.03.2023.
//

import UIKit

// MARK: - AppRouter
class AppRouter {
    
    // MARK: - Life cycle
    private init() {}
    
    // MARK: - Public properties
    static let instance = AppRouter()
    
    // MARK: - Public functions
    func startApp(window: UIWindow?) {
        showMainScreen(window: window)
    }
    
    // MARK: - Private functions
    private func showMainScreen(window: UIWindow?) {
        let newsViewController = NewsViewController.instantiateFromStoryboard()
        let presenter = NewsViewPresenter(view: newsViewController)
        newsViewController.presenter = presenter
        let navigationViewController = UINavigationController(rootViewController: newsViewController)
        window?.rootViewController = navigationViewController
    }
}
