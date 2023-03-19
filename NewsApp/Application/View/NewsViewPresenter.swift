//
//  NewsViewPresenter.swift
//  NewsApp
//
//  Created by Savka Mykhailo on 18.03.2023.
//

import UIKit

// MARK: - NewsViewPresenterProtocol
protocol NewsViewPresenterProtocol: AnyObject {
    var filteredArticles: [Article] { get }
    
    func viewLoaded()
    func searchData(by text: String)
    func segmentedControlClicked(index: Int)
    func saveButtonTapped(for index: Int)
    func detailButtonTapped(for index: Int)
}

// MARK: - NewsViewPresenter
final class NewsViewPresenter {
    
    // MARK: - Public properties
    weak var view: NewsViewControllerProtocol?
    
    // MARK: - Private properties
    private let network = NetworkManager()
    private var isSaved = false
    private var articles: [Article] = []
    private (set) var filteredArticles: [Article] = []
    
    // MARK: - Lifecycle
    init(view: NewsViewControllerProtocol) {
        self.view = view
    }
    
    // MARK: - Private methods
    private func fetchData() {
        view?.showLoader()
        network.fetchNews { [weak self] result in
            DispatchQueue.main.async {
                guard let self else { return }
                
                switch result {
                case .success(let news):
                    self.view?.hideLoader()
                    self.articles = news.articles
                    self.filteredArticles = news.articles
                    self.view?.reloadData()
                case .failure(let error):
                    self.view?.hideLoader()
                    print("Error: \(error)")
                }
            }
        }
    }
    
    private func getSavedArticles() -> [Article] {
        var savedArticles: [Article] = []
        if let articleNameList = UserDefaults.standard.array(forKey: "ArticleNameList") as? [String] {
            savedArticles = articles.filter({ articleNameList.contains($0.title) })
        }
        return savedArticles
    }
}

// MARK: - NewsViewPresenterProtocol implementation
extension NewsViewPresenter: NewsViewPresenterProtocol {
    func viewLoaded() {
        view?.setupUI()
        fetchData()
    }
    
    func searchData(by text: String) {
        if text == "" {
            filteredArticles = isSaved ? getSavedArticles() : articles
        } else {
            let lowercasedText = text.lowercased()
            filteredArticles = (isSaved ? getSavedArticles() : articles).filter({ article in
                let articleName = article.author + article.title
                let lowercasedName = articleName.lowercased()
                let trimmedName = lowercasedName.replacingOccurrences(of: " ", with: "")
                return trimmedName.contains(lowercasedText)
            })
        }
        view?.reloadData()
    }
    
    func segmentedControlClicked(index: Int) {
        filteredArticles = index == 1 ? getSavedArticles() : articles
        isSaved = index == 1
        view?.reloadData()
    }
    
    func saveButtonTapped(for index: Int) {
        let element = filteredArticles[index].title
        if var existingData = UserDefaults.standard.array(forKey: "ArticleNameList") as? [String] {
            if !existingData.contains(element) {
                existingData.append(element)
            } else {
                existingData.removeAll(where: { $0 == element })
            }
            UserDefaults.standard.set(existingData, forKey: "ArticleNameList")
        } else {
            let savedList = [element]
            UserDefaults.standard.set(savedList, forKey: "ArticleNameList")
        }
        if isSaved {
            filteredArticles = getSavedArticles()
            view?.reloadData()
        }
    }
    
    func detailButtonTapped(for index: Int) {
        if let url = URL(string: filteredArticles[index].url) {
            UIApplication.shared.open(url)
        }
    }
}
