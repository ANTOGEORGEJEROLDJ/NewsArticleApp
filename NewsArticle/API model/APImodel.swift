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

struct Article: Codable, Identifiable {
    let id = UUID()
    let title: String
    let urlToImage: String?
    let publishedAt: String?
    let description: String?
    let author: String?

    private enum CodingKeys: String, CodingKey {
        case title, description, urlToImage, publishedAt, author
    }
}



struct Source: Codable {
let name: String?
}
