//
//  APICaller.swift
//  idderezovskiyPW5
//
//  Created by Ilya Derezovskiy on 11.11.2021.
//

import Foundation

final class APICaller {
    static let shared = APICaller()
    
    struct Constants {
        static let topHeadlinesURL = URL(string:
            "https://newsapi.org/v2/top-headlines?country=us&apiKey=fefcd508852841d29aa443f10a30d307")
        static let  searchUrlString = "https://newsapi.org/v2/everything?sortBy=popularity&apiKey=fefcd508852841d29aa443f10a30d307&q="
        
    }
    
    private init() {}
    
    public func getTopStories(completion: @escaping (Result<[ArticleModel], Error>) -> Void) {
        guard let url = Constants.topHeadlinesURL else {
            return
        }
    
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
            }
            else if let data = data {
                do {
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    
                    print("Articles: \(result.articles.count)")
                    completion(.success(result.articles))
                } catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    
    public func search(with query: String, completion: @escaping (Result<[ArticleModel], Error>) -> Void) {
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        
        let urlString = Constants.searchUrlString + query
        guard let url = URL(string: urlString) else {
            return
        }
    
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
            }
            else if let data = data {
                do {
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    
                    print("Articles: \(result.articles.count)")
                    completion(.success(result.articles))
                } catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
}

struct APIResponse: Codable {
    let articles: [ArticleModel]
}

struct ArticleModel: Codable {
    var souse: Sourse?
    var title: String?
    var description: String?
    var url: String?
    var urlToImage: String?
    var publishedAt: String?
}

struct Sourse: Codable {
    var name: String?
}
