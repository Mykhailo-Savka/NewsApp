//
//  ViewControllerRepresentable.swift
//  NewsApp
//
//  Created by Savka Mykhailo on 18.03.2023.
//

import UIKit

protocol ViewControllerRepresentable: AnyObject {
    var view: UIView! { get }
}
