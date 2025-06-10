//
//  ContentView.swift
//  NewsArticle
//
//  Created by Paranjothi iOS MacBook Pro on 09/06/25.
//



import SwiftUI

struct HomeScreen: View {
    var topic: String
    @StateObject private var newsService = NewsService()
    @State private var selectedSort: SortType = .newest
    @State private var selectedCategory: String = "All"
    @Environment(\.dismiss) private var dismiss


    var body: some View {
        NavigationView {
            ZStack {
                Color(UIColor.systemGroupedBackground).ignoresSafeArea()

                ScrollView {
                    
                    HStack {
                        Button(action: {
                            dismiss()  // Navigate back to the previous screen
                        }) {
                            Image("back")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 45, height: 45)
                                .cornerRadius(15)
                        }
                        .padding(.leading, 20)
                        
                        Text("Daily News")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.horizontal, 60)
                            
                        
                        Spacer()
                    }
                    .padding(.top, 20)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("Breaking News")
                                .font(.title2)
                                .fontWeight(.semibold)
                            Spacer()
                        }
                        .padding(.horizontal)
                        .padding(.top, 16)

                        if !newsService.articles.isEmpty {
                            TopNewsCarouselView(articles: Array(newsService.articles.prefix(5)))
                        }

                        HStack {
                            Text("Recommendation")
                                .font(.title2)
                                .fontWeight(.bold)

                            Spacer()

                            Picker("Sort", selection: $selectedSort) {
                                ForEach(SortType.allCases, id: \.self) {
                                    Text($0.rawValue)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                        }
                        .padding(.horizontal)

                        LazyVStack(spacing: 20) {
                            ForEach(filteredArticles) { article in
                                NavigationLink(destination: DetailScreen(articles: article)) {
                                    NewsCardView(article: article)
                                        .padding(.horizontal)
                                }
                            }
                        }
                        .padding(.top)
                    } .padding(.top, -15)
                }
                .onAppear {
                    newsService.fetchArticles(for: topic)
                }
            }
            .navigationBarHidden(true)
        }.navigationBarBackButtonHidden()
    }

    var filteredArticles: [Article] {
        var filtered = newsService.articles
        if selectedCategory != "All" {
            filtered = filtered.filter { $0.title.lowercased().contains(selectedCategory.lowercased()) }
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
