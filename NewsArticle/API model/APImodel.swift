//
//  APImodel.swift
//  NewsArticle
//
//  Created by Paranjothi iOS MacBook Pro on 09/06/25.
//

import Foundation
import SwiftUI

struct NewsResponse: Codable {
    let articles: [Article]
}

struct Article: Codable, Identifiable, Equatable {
    // Stable ID based on title + publishedAt
    var id: String { title + (publishedAt ?? "") }

    let title: String
    let urlToImage: String?
    let publishedAt: String?
    let description: String?
    let author: String?

    private enum CodingKeys: String, CodingKey {
        case title, description, urlToImage, publishedAt, author
    }

    static func == (lhs: Article, rhs: Article) -> Bool {
        lhs.id == rhs.id
    }
}

struct Source: Codable {
    let name: String?
}
