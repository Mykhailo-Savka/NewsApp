//
//  StoryboardInstantiatable.swift
//  NewsApp
//
//  Created by Savka Mykhailo on 18.03.2023.
//

import UIKit

protocol StoryboardInstantiatable {}

extension StoryboardInstantiatable where Self: NibRepresentable {
    static func instantiateFromStoryboard(name: String = Self.identifier) -> Self {
        let storyboard = UIStoryboard(name: name, bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: Self.identifier)
        return viewController as! Self
    }
    
    static func instantiateLaunchScreen() -> Self {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: Self.identifier)
        return viewController as! Self
    }
}
