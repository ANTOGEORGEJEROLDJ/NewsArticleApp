//
//  TopNewsCarouselView.swift
//  NewsArticle
//
//  Created by Paranjothi iOS MacBook Pro on 09/06/25.
//

import SwiftUI

import SwiftUI

struct TopNewsCarouselView: View {
    let articles: [Article]
    @State private var currentIndex = 0

    var body: some View {
        VStack {
            TabView(selection: $currentIndex) {
                ForEach(Array(articles.enumerated()), id: \.offset) { index, article in
                    NavigationLink(destination: DetailScreen(articles: article)) {
                        TopNewsCard(article: article)
                            .tag(index)
                    }
                }
            }
            .frame(height: 240)
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))

            HStack(spacing: 8) {
                ForEach(0..<articles.count, id: \.self) { index in
                    Circle()
                        .fill(index == currentIndex ? Color.blue : Color.gray.opacity(0.5))
                        .frame(width: 8, height: 8)
                }
            }
        }
        .animation(.easeInOut, value: currentIndex)
    }
}
