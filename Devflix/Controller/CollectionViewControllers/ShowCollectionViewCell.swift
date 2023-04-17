//
//  MovieCollectionViewCell.swift
//  Devflix
//
//  Created by Jo Michael on 4/10/23.
//

import UIKit
import AlamofireImage

class ShowCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieImageView: UIImageView!
    
    private let baseURL = "https://image.tmdb.org/t/p/w185"
    
    func configure(with show: TVShow) {
        movieTitleLabel.text = show.name
        let imageURL = URL(string: baseURL + show.imageURL)
        movieImageView.af.setImage(withURL: imageURL!)
    }
    
}
