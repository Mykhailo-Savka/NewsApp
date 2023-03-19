//
//  NetworkManager.swift
//  NewsApp
//
//  Created by Savka Mykhailo on 18.03.2023.
//

import Foundation

// MARK: - NetworkManager
class NetworkManager {
    
    // MARK: - Private properties
    private static let path = "https://newsapi.org/v2/top-headlines?country=ua&apiKey=54c02582aa41440097b15ed9d2647740"
    
    // MARK: - Public method
    func fetchNews(completionHandler: @escaping (Result<News, Error>) -> Void) {
        if let url = URL(string: NetworkManager.path) {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    completionHandler(.failure(error))
                    return
                }
                
                guard let data else {
                    print("Error: No data")
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(News.self, from: data)
                    completionHandler(.success(response))
                } catch {
                    completionHandler(.failure(error))
                }
            }
            task.resume()
        }
    }
}
