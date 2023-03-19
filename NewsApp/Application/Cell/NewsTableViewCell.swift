//
//  NewsTableViewCell.swift
//  NewsApp
//
//  Created by Savka Mykhailo on 18.03.2023.
//

import UIKit
import Kingfisher

// MARK: - NewsTableViewCellDelegate
protocol NewsTableViewCellDelegate: AnyObject {
    func saveNewsButtonTapped(cell: UITableViewCell)
    func detailButtonTapped(cell: UITableViewCell)
}

// MARK: - NewsTableViewCell
final class NewsTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var newsImage: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var saveNewsButton: UIButton!
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
    
    // MARK: - Public properties
    weak var delegate: NewsTableViewCellDelegate?
    
    // MARK: - Private properties
    private var isSaved = false
    
    // MARK: - Lifecycle
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        saveNewsButton.setImage(UIImage(systemName: "pin"), for: .normal)
        subtitleLabel.text = nil
        descriptionLabel.text = nil
        timeLabel.text = nil
    }
    
    // MARK: - Public method
    func configure(title: String,
                   subtitle: String,
                   description: String,
                   time: String,
                   imageUrl: String?,
                   isSaved: Bool) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
        descriptionLabel.text = description
        timeLabel.text = time
        if let url = URL(string: imageUrl ?? "") {
            newsImage.kf.setImage(with: url)
        } else {
            imageHeightConstraint.constant = 0
        }
        self.isSaved = isSaved
        saveNewsButton.setImage(UIImage(systemName: isSaved ? "pin.fill" : "pin"),
                                for: .normal)
    }
    
    // MARK: - IBActions
    @IBAction private func onSaveNewsButton(_ sender: UIButton) {
        isSaved.toggle()
        saveNewsButton.setImage(UIImage(systemName: isSaved ? "pin.fill" : "pin"),
                                for: .normal)
        delegate?.saveNewsButtonTapped(cell: self)
    }
    
    @IBAction private func onDetailButton(_ sender: UIButton) {
        delegate?.detailButtonTapped(cell: self)
    }
}
