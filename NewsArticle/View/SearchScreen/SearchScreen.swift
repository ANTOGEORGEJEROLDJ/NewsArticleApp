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

    @State private var selectedSort: SortType = .newest
    @State private var selectedCategory: String = "All"

    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [.blue.opacity(0.1), .white]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                VStack(spacing: 16) {
                    // 🔹 Filter Bar
                    HStack {
                        HStack {
                            Image(systemName: "arrow.up.arrow.down")
                            Picker("Sort", selection: $selectedSort) {
                                ForEach(SortType.allCases, id: \.self) { sort in
                                    Text(sort.rawValue)
                                }
                            }
                        }
                        .padding(10)
                        .background(.ultraThinMaterial)
                        .cornerRadius(12)

                        Spacer()

                        HStack {
                            Image(systemName: "line.3.horizontal.decrease.circle")
                            Picker("Category", selection: $selectedCategory) {
                                Text("All").tag("All")
                                Text("Business").tag("Business")
                                Text("Technology").tag("Technology")
                                Text("Sports").tag("Sports")
                                Text("Health").tag("Health")
                                Text("Science").tag("Science")
                            }
                        }
                        .padding(10)
                        .background(.ultraThinMaterial)
                        .cornerRadius(12)
                    }
                    .font(.subheadline)
                    .padding(.horizontal)

                    // 🔹 Search Result or Placeholder
                    if filteredArticles.isEmpty {
                        Spacer()
                        VStack(spacing: 12) {
                            Image(systemName: "doc.text.magnifyingglass")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 80)
                                .foregroundColor(.gray.opacity(0.4))

                            Text(searchText.isEmpty ? "Start typing to search articles" : "No results found.")
                                .font(.body)
                                .foregroundColor(.gray)
                        }
                        .padding(.bottom, 100)
                        Spacer()
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 16) {
                                ForEach(filteredArticles) { article in
                                    NavigationLink(destination: DetailScreen(articles: article)) {
                                        NewsCardView(article: article)
                                            .background(.ultraThinMaterial)
                                            .cornerRadius(20)
                                            .shadow(color: .gray.opacity(0.3), radius: 10, x: 0, y: 5)
                                            .padding(.horizontal)
                                    }
                                }
                            }
                            .padding(.top, 10)
                        }
                    }
                }
                .navigationTitle("🔎 Search News")
                .searchable(text: $searchText, prompt: "Type something...")
                
                .onChange(of: searchText) { newText in
                    if newText.count > 2 {
                        searchArticles(keyword: newText)
                    } else {
                        searchedArticles = []
                    }
                }
            }
        }
    }

    // 🔹 Filtering and Sorting Logic
    var filteredArticles: [Article] {
        var filtered = searchedArticles

        if selectedCategory != "All" {
            filtered = filtered.filter { article in
                article.title.lowercased().contains(selectedCategory.lowercased())
            }
        }

        switch selectedSort {
        case .newest:
            filtered.sort { ($0.publishedAt ?? "") > ($1.publishedAt ?? "") }
        case .oldest:
            filtered.sort { ($0.publishedAt ?? "") < ($1.publishedAt ?? "") }
        }

        return filtered
    }

    // 🔹 Search API Call
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
