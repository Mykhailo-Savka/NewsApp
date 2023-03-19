//
//  NibLoadable+Helpers.swift
//  NewsApp
//
//  Created by Savka Mykhailo on 18.03.2023.
//

import UIKit

// MARK: - NibLoadable protocol
public protocol NibLoadable {
    static var nibName: String { get }
}

// MARK: - NibLoadable extension
public extension NibLoadable where Self: UIView {
    
    static var nibName: String {
        return String(describing: Self.self)
    }
    
    func xibSetup() {
        guard let view = loadViewFromNib() else { return }
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
        view.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        view.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
        view.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
    }
    
    func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: Self.nibName, bundle: bundle)
        return nib.instantiate(
            withOwner: self,
            options: nil).first as? UIView
    }
}
