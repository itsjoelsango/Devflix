//
//  MovieTableViewCell.swift
//  Devflix
//
//  Created by Jo Michael on 4/5/23.
//

import UIKit
import AlamofireImage

class MovieTableViewCell: UITableViewCell {
    
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieDescription: UILabel!
    @IBOutlet weak var movieReleasedYearLabel: UILabel!
    @IBOutlet weak var movieLanguage: UILabel!
    @IBOutlet weak var movieImageView: UIImageView!
    
    private let baseURL = "https://image.tmdb.org/t/p/w185"
    
    func configure(with movie: Movie) {
        movieTitleLabel.text = movie.name
        movieDescription.text = movie.description
        movieReleasedYearLabel.text = movie.releasedDate
        movieLanguage.text = "Language: \(movie.originalLanguage.uppercased())"
        
        let imageURL = URL(string: baseURL + movie.imageURL)
        movieImageView.af.setImage(withURL: imageURL!)
    }
}
