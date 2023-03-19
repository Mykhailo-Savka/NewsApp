//
//  Article.swift
//  NewsApp
//
//  Created by Savka Mykhailo on 18.03.2023.
//

import Foundation

// MARK: - Article
struct Article: Codable, Equatable {
    let source: Source
    let author, title: String
    let description: String?
    let url: String
    let urlToImage: String?
    let publishedAt: String
    let content: String?
}
