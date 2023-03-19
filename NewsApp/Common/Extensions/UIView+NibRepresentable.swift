//
//  UIView+NibRepresentable.swift
//  NewsApp
//
//  Created by Savka Mykhailo on 18.03.2023.
//

import UIKit

extension UIView: NibRepresentable {
    class var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    class var identifier: String {
        return String(describing: self)
    }
}

extension NibRepresentable where Self: UIView {
    static var viewFromNib: Self {
        return Bundle.main.loadNibNamed(
            Self.identifier,
            owner: nil, options: nil)?.first as! Self
    }
}
