//
//  NewsService.swift
//  NewsArticle
//
//  Created by Paranjothi iOS MacBook Pro on 09/06/25.
//

import Foundation

class NewsService: ObservableObject {
    @Published var articles: [Article] = []
    
    func fetchArticles() {
        let urlString = "https://newsapi.org/v2/everything?q=tesla&from=2025-05-09&sortBy=publishedAt&apiKey=cc25bb5dcf664f72b46179809c871f6e"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data {
                do {
                    let decoded = try JSONDecoder().decode(NewsResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.articles = decoded.articles
                    }
                } catch {
                    print("Decoding error: \(error)")
                }
            }
        }.resume()
    }
    
    func searchArticles(query: String, completion: @escaping (Result<[Article], Error>) -> Void) {
        let apiKey = "YOUR_NEWS_API_KEY"
        let urlString = "https://newsapi.org/v2/everything?q=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")&apiKey=\(apiKey)"
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else { return }
            do {
                let response = try JSONDecoder().decode(NewsResponse.self, from: data)
                completion(.success(response.articles))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
