//
//  ViewController.swift
//  Devflix
//
//  Created by Jo Michael on 4/5/23.
//

import UIKit

private var filteredMovies = [MovieDetail]()

class MovieViewController: UIViewController {
    
    @IBOutlet weak var movieTableView: UITableView!
    private var refreshControl: UIRefreshControl!
    
    private var movies = [MovieDetail]() {
        didSet {
            filteredMovies = self.movies
            movieTableView.reloadData()
        }
    }
    
    // MARK: SearchController configuration
    let searchController = UISearchController()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.searchController = searchController
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        navigationItem.hidesSearchBarWhenScrolling = false
        
        // init refresherControl here
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(pulledToRefresh), for: .valueChanged)
        
        movieTableView.dataSource = self
        movieTableView.delegate = self
        movieTableView.refreshControl = refreshControl

        getAllMovies()
          
    }
    
    @objc private func pulledToRefresh() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.getAllMovies()
            self?.movieTableView.reloadData()
            self?.refreshControl.endRefreshing()
        }
    }
    
    private func getAllMovies() {
        var allMovies = [MovieDetail]()
        
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
            let detailMovieViewController = segue.destination as? FlixDetailViewController
            let selectedTow = movieTableView.indexPathForSelectedRow
            let id = movies[selectedTow!.row].id
            detailMovieViewController?.movieDetailConfigure(with: id)
        }
    }


}

// MARK: UITableview Extension
extension MovieViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableviewCellIndentifier") as? MovieTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: filteredMovies[indexPath.row])
        return cell
    }
}

// MARK: UISearchController extension
extension MovieViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchString = searchController.searchBar.text, searchString.isEmpty == false {
            filteredMovies = movies.filter{ (movie) -> Bool in
                movie.title.localizedCaseInsensitiveContains(searchString)
            }
        } else {
            filteredMovies = movies
        }
        
        self.movieTableView.reloadData()
    }
}

