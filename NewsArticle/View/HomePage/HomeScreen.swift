//
//  ContentView.swift
//  NewsArticle
//
//  Created by Paranjothi iOS MacBook Pro on 09/06/25.
//



import SwiftUI

struct HomeScreen: View {
    @StateObject private var newsService = NewsService()
    @State private var selectedSort: SortType = .newest
    @State private var selectedCategory: String = "All"

    let topic: String

    var body: some View {
        NavigationView {
            ZStack {
                Color(UIColor.systemGroupedBackground).ignoresSafeArea()
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        // Header
                        HStack {
                            Text("Breaking News")
                                .font(.title2)
                                .fontWeight(.semibold)

                            Spacer()

                            Picker("Category", selection: $selectedCategory) {
                                Text("All").tag("All")
                                Text("Business").tag("Business")
                                Text("Technology").tag("Technology")
                            }
                            .pickerStyle(MenuPickerStyle())
                        }
                        .padding(.horizontal)
                        .padding(.top, 16)

                        // Carousel
                        if !newsService.articles.isEmpty {
                            TopNewsCarouselView(articles: Array(newsService.articles.prefix(5)))
                        }

                        // Recommendations
                        HStack {
                            Text("Recommendation")
                                .font(.title2)
                                .fontWeight(.bold)
                            Spacer()
                            Picker("Sort", selection: $selectedSort) {
                                ForEach(SortType.allCases, id: \.self) {
                                    Text($0.rawValue)
                                }
                            }.pickerStyle(MenuPickerStyle())
                        }.padding(.horizontal)

                        // Articles
                        LazyVStack(spacing: 20) {
                            ForEach(filteredArticles) { article in
                                NavigationLink(destination: DetailScreen(articles: article)) {
                                    NewsCardView(article: article)
                                        .padding(.horizontal)
                                }
                            }
                        }
                        .padding(.top)
                    }
                }
                .onAppear {
                    newsService.fetchArticles(for: topic)
                }
            }
            .navigationBarHidden(true)
        }
    }

    var filteredArticles: [Article] {
        var filtered = newsService.articles

        if selectedCategory != "All" {
            filtered = filtered.filter {
                $0.title.lowercased().contains(selectedCategory.lowercased())
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
}


enum SortType: String, CaseIterable {
    case newest = "Newest"
    case oldest = "Oldest"
}
