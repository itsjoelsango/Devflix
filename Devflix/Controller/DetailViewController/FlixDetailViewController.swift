//
//  MovieCollectionViewDetailViewController.swift
//  Devflix
//
//  Created by Jo Michael on 4/14/23.
//

import UIKit

class FlixDetailViewController: UIViewController {

    @IBOutlet weak var showBackdopImageView: UIImageView!
    @IBOutlet weak var showImageView: UIImageView!
    @IBOutlet weak var showTitleLabel: UILabel!
    @IBOutlet weak var showOriginalNameLabel: UILabel!
    @IBOutlet weak var showDescriptionLabel: UILabel!
    @IBOutlet weak var showLanguageLabel: UILabel!
    @IBOutlet weak var showReleasedDateLabel: UILabel!
    
    private let baseURL = "https://image.tmdb.org/t/p/w185"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func configure(with id: Int) {
        MovieService.shared.fetchTvShowDetail(id: id) { [weak self] tvShowDetail in
            self?.showTitleLabel.text = "Translated Name: \(tvShowDetail.name)"
            self?.showOriginalNameLabel.text = "Original Name: \(tvShowDetail.originalName)"
            self?.showDescriptionLabel.text = tvShowDetail.description
            self?.showLanguageLabel.text = "Language: \(tvShowDetail.language)"
            self?.showReleasedDateLabel.text = "Released Date: \(tvShowDetail.releasedYear)"
            
            let imageURL = URL(string: self!.baseURL + tvShowDetail.imageURL)
            let backdropImageURL = URL(string: self!.baseURL + tvShowDetail.backdropImageURL)
            
            if let image = imageURL {
                self?.showImageView.af.setImage(withURL: image)
            } else {
                self?.showImageView.image = UIImage(systemName: "photo")
            }
            if let backdropImage = backdropImageURL {
                self?.showBackdopImageView.af.setImage(withURL: backdropImage)
            } else {
                self?.showBackdopImageView.image = UIImage(systemName: "photo")
            }
        }
    }
    
    func movieDetailConfigure(with id: Int) {
        MovieService.shared.fetchMovieDetail(id: id) { [weak self] movieDetail in
            self?.showTitleLabel.text = "Translated Name: \(movieDetail.title)"
            self?.showOriginalNameLabel.text = "Original Name: \(movieDetail.originalTitle)"
            self?.showDescriptionLabel.text = movieDetail.description
            self?.showLanguageLabel.text = "Language: \(movieDetail.originalLanguage)"
            self?.showReleasedDateLabel.text = "Released Date: \(movieDetail.releasedDate)"
            
            let imageURL = URL(string: self!.baseURL + movieDetail.imageURL)
            let backdropImageURL = URL(string: self!.baseURL + movieDetail.backdropImage)
            
            if let image = imageURL {
                self?.showImageView.af.setImage(withURL: image)
            } else {
                self?.showImageView.image = UIImage(systemName: "photo")
            }
            if let backdropImage = backdropImageURL {
                self?.showBackdopImageView.af.setImage(withURL: backdropImage)
            } else {
                self?.showBackdopImageView.image = UIImage(systemName: "photo")
            }
        }
    }


}
