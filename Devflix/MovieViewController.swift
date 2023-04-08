//
//  ViewController.swift
//  Devflix
//
//  Created by Jo Michael on 4/5/23.
//

import UIKit

class MovieViewController: UIViewController {
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
//        MovieService.shared.fetchMovie { movies in
//            self.movies = movies
//        }
        getAllMovies()
    }
    
    private func getAllMovies() {
        var allMovies = [Movie]()
        
        try? NetworkManager.moviesPage1(completionHandler: { result in
            switch result {
            case .success(let movies):
                allMovies += movies.results
                self.movies = allMovies
            case .failure(let failure):
                print(failure)
            }
        })
        try? NetworkManager.moviesPage2(completionHandler: { result in
            switch result {
            case .success(let movies):
                allMovies += movies.results
                self.movies = allMovies
            case .failure(let failure):
                print(failure)
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetail" {
            let detailMovieViewController = segue.destination as? MovieDetailViewController
            let selectedTow = movieTableView.indexPathForSelectedRow
            let id = movies[selectedTow!.row].id
            detailMovieViewController?.configure(with: id)
        }
    }


}

// MARK: UITableview DataSource
extension MovieViewController: UITableViewDataSource {
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

// MARK: TableView delegate
extension MovieViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 150.0
//    }
}

