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
    
    func fetchTvShows(completion: @escaping(([TVShow]) -> Void)) {
        let url = URL(string: "https://api.themoviedb.org/3/tv/top_rated?api_key=\(MovieServiceAPIKey.apiKey)")!
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
            let tvShowRawData = dataDictionary["results"] as! [[String: Any]]
            var tvShows = [TVShow]()
            for rawData in tvShowRawData {
                let tvShow = TVShow(id: rawData["id"] as! Int,
                                    name: rawData["name"] as! String,
                                    originalName: rawData["original_name"] as! String,
                                    description: rawData["overview"] as! String,
                                    language: rawData["original_language"] as! String,
                                    releasedYear: rawData["first_air_date"] as! String,
                                    imageURL: rawData["poster_path"] as? String ?? "",
                                    backdropImageURL: rawData["backdrop_path"] as! String
                )
                tvShows.append(tvShow)
            }
            completion(tvShows)
        }
        task.resume()
    }
    
    func fetchTvShowDetail(id: Int, completionHandler: @escaping(TVShow) -> Void) {
        let url = URL(string: "https://api.themoviedb.org/3/tv/\(id)?api_key=\(MovieServiceAPIKey.apiKey)&append_to_response=videos,images")!
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
                    let tvShowDetail = try decoder.decode(TVShow.self, from: data)
                    completionHandler(tvShowDetail)
                } catch let error {
                    print(error.localizedDescription)
                    return
                }
            }
        }
        task.resume()
        
    }
}
