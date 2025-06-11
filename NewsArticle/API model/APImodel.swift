//
//  APImodel.swift
//  NewsArticle
//
//  Created by Paranjothi iOS MacBook Pro on 09/06/25.
//

import Foundation

struct NewsResponse: Codable {
    let articles: [Article]
}

struct Article: Codable, Identifiable, Equatable {
    var id: String { title + (publishedAt ?? "") }
    let title: String
    let urlToImage: String?
    let publishedAt: String?
    let description: String?
    let author: String?

    static func == (lhs: Article, rhs: Article) -> Bool {
        lhs.id == rhs.id
    }
}


struct Source: Codable {
    let name: String?
}
