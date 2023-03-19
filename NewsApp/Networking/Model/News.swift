//
//  News.swift
//  NewsApp
//
//  Created by Savka Mykhailo on 18.03.2023.
//

import Foundation

// MARK: - News
struct News: Codable, Equatable {
    let status: String
    let totalResults: Int
    let articles: [Article]
}
