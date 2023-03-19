//
//  NibRepresentable.swift
//  NewsApp
//
//  Created by Savka Mykhailo on 18.03.2023.
//

import UIKit

protocol NibRepresentable {
    static var nib: UINib { get }
    static var identifier: String { get }
}
