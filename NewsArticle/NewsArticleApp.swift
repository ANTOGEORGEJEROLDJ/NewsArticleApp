//
//  NewsArticleApp.swift
//  NewsArticle
//
//  Created by Paranjothi iOS MacBook Pro on 09/06/25.
//

import SwiftUI

@main
struct NewsArticleApp: App {
    
//    let sampleArticle = Article(
//        title: "Sample Title",
//        urlToImage: "https://picsum.photos/400/300", // ✅ valid image
//        publishedAt: "2025-06-08T08:35:09Z",
//        description: "Sample description about Tesla, tech, and more...",
//        author: "News Author"
//    )

    var body: some Scene {
        WindowGroup {
            NavigationView {
                TapView()
            }
        }
    }
}
