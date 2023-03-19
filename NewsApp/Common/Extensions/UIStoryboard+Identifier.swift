//
//  UIStoryboard+Identifier.swift
//  NewsApp
//
//  Created by Savka Mykhailo on 18.03.2023.
//

import UIKit

extension UIStoryboard {
    var identifier: String {
        return String(describing: self)
    }
}
