//
//  NetworkManager.swift
//  Devflix
//
//  Created by Jo Michael on 4/8/23.
//

import Foundation

struct NetworkManager {
    private init() {}
    
    static let shared = NetworkManager()
    
    fileprivate static let api = "https://api.themoviedb.org/3/movie/now_playing?api_key=\(MovieServiceAPIKey.apiKey)"
    
    static var decoder: JSONDecoder = {
        let dec = JSONDecoder()
        dec.dateDecodingStrategy = .iso8601
        return dec
    }()
    
    enum RequestType: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case delete = "DELETE"
    }
    
    enum RequestError: Error {
        case notFound
        case badRequest
        case uncategorized
        case decodingError(Error)
    }
    
    typealias Handler<Success> = (Result<Success, RequestError>) -> Void
    
    // MARK: fetch data
    static func allMovies(completionHandler: @escaping Handler<MovieListItem>) throws {
        try networkRequest(completionHandler: completionHandler)
    }
    
    // MARK: Default route
    static func moviesPage1(completionHandler: @escaping Handler<MovieListItem>) throws {
        try networkRequest(completionHandler: completionHandler)
    }
    //MARK: Request data from page 2
    static func moviesPage2(completionHandler: @escaping Handler<MovieListItem>) throws {
        try networkRequest(route: "2", completionHandler: completionHandler)
    }
    //MARK: Request data from page 3
    static func moviesPage3(completionHandler: @escaping Handler<MovieListItem>) throws {
        try networkRequest(route: "3", completionHandler: completionHandler)
    }
    
    private static func networkRequest<T: Codable>(route: String = "1", completionHandler: @escaping (Result<T, RequestError>) -> Void) throws {
        guard let url = URL(string: api + "&page=" + route) else {
            print("Bad path...")
            return
        }
        
        let request = URLRequest(url: url,
                                 cachePolicy: .reloadIgnoringLocalCacheData,
                                 timeoutInterval: 10)
        let session = URLSession(configuration: .default,
                                 delegate: nil,
                                 delegateQueue: .main)
        let task = session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                print("got an error")
                completionHandler(.failure(.uncategorized))
                return
            }
            guard let response = response as? HTTPURLResponse else {
                completionHandler(.failure(.uncategorized))
                return
            }
            guard let data = data else {
                print("got no data")
                completionHandler(.failure(.uncategorized))
                return
            }
            
            if response.statusCode == 200 {
                do {
                    let dataDictionary = try decoder.decode(T.self, from: data)
                    completionHandler(.success(dataDictionary))
                    return
                } catch {
                    print(error.localizedDescription)
                    completionHandler(.failure(.decodingError(error)))
                    return
                }
            }
            switch response.statusCode {
                case 404: completionHandler(.failure(.notFound))
                case 400: completionHandler(.failure(.badRequest))
                default: completionHandler(.failure(.uncategorized))
            }
        }
        task.resume()
    }
}
