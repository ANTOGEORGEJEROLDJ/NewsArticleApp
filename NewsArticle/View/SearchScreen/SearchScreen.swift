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
            VStack {
                // 🔹 Filter Bar
                HStack {
                    Picker("Sort", selection: $selectedSort) {
                        ForEach(SortType.allCases, id: \.self) { sort in
                            Text(sort.rawValue)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    
                    Spacer()
                    
                    Picker("Category", selection: $selectedCategory) {
                        Text("All").tag("All")
                        Text("Business").tag("Business")
                        Text("Technology").tag("Technology")
                        Text("Sports").tag("Sports")
                        Text("Health").tag("Health")
                        Text("Science").tag("Science")
                    }
                    .pickerStyle(MenuPickerStyle())
                }
                .padding(.horizontal)

                // 🔹 Empty State or Results
                if filteredArticles.isEmpty {
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
                    List(filteredArticles) { article in
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
            filtered.sort { $0.publishedAt! > $1.publishedAt! }
        case .oldest:
            filtered.sort { $0.publishedAt! < $1.publishedAt! }
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

//// 🔹 Sorting Type Enum
//enum SortType: String, CaseIterable {
//    case newest = "Newest"
//    case oldest = "Oldest"
//}
