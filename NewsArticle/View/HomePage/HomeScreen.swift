//
//  ContentView.swift
//  NewsArticle
//
//  Created by Paranjothi iOS MacBook Pro on 09/06/25.
//



import SwiftUI

struct HomeScreen: View {
    @StateObject private var newsService = NewsService()
    
    // Filter States
    @State private var selectedSort: SortType = .newest
    @State private var selectedCategory: String = "All"
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(colors: [.white, .blue.opacity(0.05)], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        
                        // MARK: - Header
                        HStack {
                            Text("Breaking News")
                                .font(.title2)
                                .fontWeight(.semibold)
                            Spacer()
                            // 🔹 Category Filter
                            Picker("Category", selection: $selectedCategory) {
                                Text("All").tag("All")
                                Text("Business").tag("Business")
                                Text("Technology").tag("Technology")
                                Text("Sports").tag("Sports")
                                Text("Health").tag("Health")
                                Text("Science").tag("Science")
                            }
                            .pickerStyle(MenuPickerStyle())
                            .padding(.horizontal)
                        }
                        .padding(.horizontal)
                        .padding(.top, 16)
                        
                        // MARK: - Horizontal Top News
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(newsService.articles.prefix(5)) { article in
                                    NavigationLink(destination: DetailScreen(articles: article)) {
                                        TopNewsCard(article: article)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                        // MARK: - Recommendation Header
                        HStack {
                            Text("Recommendation")
                                .font(.title2)
                                .fontWeight(.bold)
                            Spacer()
                            // 🔹 Sort Filter
                            Picker("Sort", selection: $selectedSort) {
                                ForEach(SortType.allCases, id: \.self) { sort in
                                    Text(sort.rawValue)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            .padding(.horizontal)
                        }
                        .padding(.horizontal)
                        
                        // MARK: - Filtered News List
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
                    newsService.fetchArticles()
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    // MARK: - Filter & Sort Logic
    var filteredArticles: [Article] {
        var filtered = newsService.articles
        
        if selectedCategory != "All" {
            filtered = filtered.filter {
                $0.title.lowercased().contains(selectedCategory.lowercased())
            }
        }
        
        switch selectedSort {
        case .newest:
            filtered.sort { $0.publishedAt! > $1.publishedAt! }
        case .oldest:
            filtered.sort { $0.publishedAt! < $1.publishedAt! }
        }
        
        return filtered
    }
}

// MARK: - Sort Type Enum (Shared across app)
enum SortType: String, CaseIterable {
    case newest = "Newest"
    case oldest = "Oldest"
}
