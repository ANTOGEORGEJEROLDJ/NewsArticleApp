//
//  SearchScreen.swift
//  NewsArticle
//
//  Created by Paranjothi iOS MacBook Pro on 09/06/25.
//

import SwiftUI

struct SearchScreen: View {
    @State private var searchText = ""
    @StateObject private var newsService = NewsService()
    @State private var searchedArticles: [Article] = []
    
    var body: some View {
        NavigationView {
            VStack {
                if searchedArticles.isEmpty {
                    Spacer()
                    VStack {
                        Image(systemName: "doc.text.magnifyingglass")
                            .font(.system(size: 50))
                            .padding(.bottom, 10)
                        Text("Start typing to search articles")
                            .foregroundColor(.gray)
                            .font(.subheadline)
                    }
                    Spacer()
                } else {
                    List(searchedArticles) { article in
                        NavigationLink(destination: DetailScreen(articles: article)) {
                            NewsCardView(article: article)
                        }
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("Search")
            .searchable(text: $searchText, prompt: "Search News")
            .onChange(of: searchText) { newText in
                if newText.count > 2 {
                    searchArticles(keyword: newText)
                } else {
                    searchedArticles = []
                }
            }
        }
    }
    
    func searchArticles(keyword: String) {
        newsService.searchArticles(query: keyword) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let articles):
                    self.searchedArticles = articles
                case .failure(let error):
                    print("Search error:", error.localizedDescription)
                    self.searchedArticles = []
                }
            }
        }
    }
}
