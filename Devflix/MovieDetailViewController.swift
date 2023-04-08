//
//  MovieDetailViewController.swift
//  Devflix
//
//  Created by Jo Michael on 4/8/23.
//

import UIKit

class MovieDetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    func configure(with id: Int) {
        MovieService.shared.fetchMovieDetail(id: id) { [weak self] movieDetail in
            self?.nameLabel.text = movieDetail.name
        }
    }
}
