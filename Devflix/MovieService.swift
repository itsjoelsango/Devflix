//
//  MovieService.swift
//  Devflix
//
//  Created by Jo Michael on 4/5/23.
//

import Foundation

class MovieService {
    static let shared = MovieService()
    
    func fetchMovie(completion: @escaping(([Movie]) -> Void)) {
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(MovieServiceAPIKey.apiKey)")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default,
                                 delegate: nil,
                                 delegateQueue: .main)
        let task = session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                print("got an error")
                return
            }
            guard let data = data else {
                print("got no data")
                return
            }
            let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
            let moviesRawData = dataDictionary["results"] as! [[String: Any]]
            var movies = [Movie]()
            for rawData in moviesRawData {
                let movie = Movie(name: rawData["original_title"] as! String,
                                  description: rawData["overview"] as! String,
                                  releasedDate: rawData["release_date"] as! String,
                                  originalLanguage: rawData["original_language"] as! String,
                                  imageURL: rawData["poster_path"] as! String)
                movies.append(movie)
            }
            completion(movies)
        }
        task.resume()
    }
}
