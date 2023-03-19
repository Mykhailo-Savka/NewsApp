//
//  NewsViewController.swift
//  NewsApp
//
//  Created by Savka Mykhailo on 18.03.2023.
//

import UIKit

// MARK: - NewsViewControllerProtocol
protocol NewsViewControllerProtocol: AnyObject {
    func setupUI()
    func showLoader()
    func hideLoader()
    func reloadData()
}

// MARK: - NewsViewController
final class NewsViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var segmentedControl: UISegmentedControl!
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Public properties
    var presenter: NewsViewPresenterProtocol!
    
    // MARK: - Private properties
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewLoaded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    // MARK: - Private methods
    private func convertDate(from dateString: String) -> String? {
        let ISODateFormatter = ISO8601DateFormatter()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        if let date = ISODateFormatter.date(from: dateString) {
            return dateFormatter.string(from: date)
        }
        return nil
    }
    
    private func setupActivityIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    // MARK: - IBAction
    @IBAction func segmentedControlClicked(_ sender: UISegmentedControl) {
        presenter.segmentedControlClicked(index: segmentedControl.selectedSegmentIndex)
    }
}

// MARK: - NewsViewControllerProtocol implementation
extension NewsViewController: NewsViewControllerProtocol {
    func setupUI() {
        tableView.dataSource = self
        searchBar.delegate = self
        tableView.registerCell(NewsTableViewCell.self)
        tableView.keyboardDismissMode = .onDrag
        setupActivityIndicator()
    }
    
    func showLoader() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func hideLoader() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    func reloadData() {
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource implementation
extension NewsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if presenter.filteredArticles.count == 0 {
            self.tableView.setEmptyMessage("No data")
        } else {
            self.tableView.restore()
        }
        return presenter.filteredArticles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(NewsTableViewCell.self, indexPath: indexPath)
        cell.delegate = self
        let article = presenter.filteredArticles[indexPath.row]
        let isSaved: Bool
        if let articleNameList = UserDefaults.standard.array(forKey: "ArticleNameList") as? [String],
           articleNameList.contains(article.title) {
            isSaved = true
        } else {
            isSaved = false
        }
        cell.configure(title: article.author,
                       subtitle: article.title,
                       description: article.description ?? "",
                       time: convertDate(from: article.publishedAt) ?? "",
                       imageUrl: article.urlToImage,
                       isSaved: isSaved)
        return cell
    }
}

// MARK: - UISearchBarDelegate implementation
extension NewsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter.searchData(by: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

// MARK: - NewsTableViewCellDelegate implementation
extension NewsViewController: NewsTableViewCellDelegate {
    func saveNewsButtonTapped(cell: UITableViewCell) {
        if let index = tableView.indexPath(for: cell) {
            presenter.saveButtonTapped(for: index.row)
        }
    }
    
    func detailButtonTapped(cell: UITableViewCell) {
        if let index = tableView.indexPath(for: cell) {
            presenter.detailButtonTapped(for: index.row)
        }
    }
}
