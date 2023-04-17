//
//  MovieCollectionViewController.swift
//  Devflix
//
//  Created by Jo Michael on 4/10/23.
//

import UIKit

private let reuseIdentifier = "Movie"

class ShowCollectionViewController: UICollectionViewController {
    fileprivate var filteredTvShows: [TVShow] = []
    private var tvShows = [TVShow]() {
        didSet {
            filteredTvShows = self.tvShows
            collectionView.reloadData()
        }
    }
    
    // MARK: SearchController configuration
    private let searchController = UISearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.searchController = searchController
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        navigationItem.hidesSearchBarWhenScrolling = false
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.5))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 3)

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        section.interGroupSpacing = 8
        
        collectionView.collectionViewLayout = UICollectionViewCompositionalLayout(section: section)
        
        getAllTvShows()
        
    }
    
    private func getAllTvShows() {
        MovieService.shared.fetchTvShows { tvShows in
            self.tvShows = tvShows
        }
    }
    
    // MARK: Pass data from collectionView to another View via a segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let movieCollectionViewDetailController = segue.destination as? FlixDetailViewController
            let cell = sender as! UICollectionViewCell
            let indexPath = collectionView.indexPath(for: cell)
            let selectedRow = tvShows[(indexPath?.row)!].id
            movieCollectionViewDetailController?.configure(with: selectedRow)
        }
    }

    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredTvShows.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? ShowCollectionViewCell else { return UICollectionViewCell() }
        let tvshow = filteredTvShows[indexPath.item]
        cell.configure(with: tvshow)
        
        return cell
    }

}

// MARK: UISearchController extension and configuration
extension ShowCollectionViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchTvShow = searchController.searchBar.text, searchTvShow.isEmpty == false {
            filteredTvShows = tvShows.filter { (tvshow) -> Bool in
                tvshow.name.localizedCaseInsensitiveContains(searchTvShow)
            }
        } else {
            filteredTvShows = tvShows
        }
        
        collectionView.reloadData()
    }
}
