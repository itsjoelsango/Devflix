//
//  ViewController.swift
//  Devflix
//
//  Created by Jo Michael on 4/5/23.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var movieTableView: UITableView!
    private var movies = [Movie]() {
        didSet {
            movieTableView.reloadData()
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        movieTableView.dataSource = self
        movieTableView.delegate = self
        MovieService.shared.fetchMovie { movies in
            self.movies = movies
        }
    }


}

// UITableview DataSource
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableviewCellIndentifier") as? MovieTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: movies[indexPath.row])
        return cell
    }
    
    
}

// TableView delegate
extension ViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 150.0
//    }
}

