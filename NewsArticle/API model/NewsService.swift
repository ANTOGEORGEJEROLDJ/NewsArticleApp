//
//  NewsService.swift
//  NewsArticle
//
//  Created by Paranjothi iOS MacBook Pro on 09/06/25.
//

import Foundation

class NewsService: ObservableObject {
    @Published var articles: [Article] = []

    func fetchArticles(for topic: String) {
        let query = topic.lowercased().replacingOccurrences(of: " ", with: "")
        var urlString = ""

        switch query {
        case "applenews":
            urlString = "https://https://newsapi.org/v2/everything?q=apple&from=2025-06-10&to=2025-06-10&sortBy=popularity&apiKey=cc25bb5dcf664f72b46179809c871f6e"
        case "businessnews":
            urlString = "https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey==cc25bb5dcf664f72b46179809c871f6e"
        case "teslanews":
            urlString = "https://newsapi.org/v2/everything?q=tesla&from=2025-05-11&sortBy=publishedAt&apiKey=cc25bb5dcf664f72b46179809c871f6e"
        case "techcrunch":
            urlString = "https://newsapi.org/v2/top-headlines?sources=techcrunch&apiKey=cc25bb5dcf664f72b46179809c871f6e"
        case "wallstreetjournal":
            urlString = "https://newsapi.org/v2/everything?domains=wsj.com&apiKey=cc25bb5dcf664f72b46179809c871f6e"
        default:
            urlString = "https://newsapi.org/v2/everything?q=\(query)&apiKey=cc25bb5dcf664f72b46179809c871f6e"
        }

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
        let apiKey = "cc25bb5dcf664f72b46179809c871f6e"
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
