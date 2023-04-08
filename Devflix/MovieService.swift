//
//  MovieService.swift
//  Devflix
//
//  Created by Jo Michael on 4/5/23.
//

import Foundation

class MovieService {
    private init() {}
    
    static let shared = MovieService()
    
    let session = URLSession(configuration: .default,
                             delegate: nil,
                             delegateQueue: .main)
    
    func fetchMovie(completion: @escaping(([Movie]) -> Void)) {
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(MovieServiceAPIKey.apiKey)")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)

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
                let movie = Movie(id: rawData["id"] as! Int, name: rawData["original_title"] as! String,
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
    
    func fetchMovieDetail(id: Int, completionHandler: @escaping(MovieDetail) -> Void) {
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(id)?api_key=\(MovieServiceAPIKey.apiKey)&append_to_response=videos,images")!
        let request = URLRequest(url: url,
                                 cachePolicy: .reloadIgnoringLocalCacheData,
                                 timeoutInterval: 10)
        let task = session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                print("got an error")
                return
            }
            guard let response = response as? HTTPURLResponse else {
                return
            }
            guard let data = data else {
                print("got no data")
                return
            }
            
            if response.statusCode == 200 {
                let decoder = JSONDecoder()
                do {
                    let movieDetail = try decoder.decode(MovieDetail.self, from: data)
                    completionHandler(movieDetail)
                } catch let error {
                    print(error.localizedDescription)
                    return
                }
            }
        }
        task.resume()
        
    }
}
