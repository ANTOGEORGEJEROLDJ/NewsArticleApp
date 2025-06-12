//
//  SavedScreen.swift
//  NewsArticle
//
//  Created by Paranjothi iOS MacBook Pro on 11/06/25.
//

import SwiftUI

struct HomeScreen: View {
    var topic: String
    var username: String
    var email: String
    @Binding var isSignedIn: Bool

    @StateObject private var newsService = NewsService()
    @State private var selectedSort: SortType = .newest
    @State private var selectedCategory: String = "All"
    @State private var hasLoaded = false

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [.white.opacity(0.2), .white]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        // Header
                        HStack {
                            Button(action: {
                                dismiss()
                            }) {
                                Image("back")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 45, height: 45)
                                    .cornerRadius(15)
                            }

                            Spacer()

                            Text("📰 Daily News")
                                .font(.system(size: 24, weight: .bold, design: .rounded))
                                .foregroundColor(.primary)

                            Spacer()

                            NavigationLink(destination:ProfileScreen(UserName: username, email: email, isSignedIn: TapView.$isSignedIn)) {
                                Image(systemName: "person.circle.fill")
                                    .font(.largeTitle)
                                    .foregroundColor(.gray.opacity(0.7))
                            }
                        }
                        .padding(.horizontal)

                        // Breaking News
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Breaking News")
                                .font(.title3)
                                .bold()
                                .padding(.horizontal)

                            if !newsService.articles.isEmpty {
                                TopNewsCarouselView(articles: Array(newsService.articles.prefix(5)))
                                    .transition(.slide)
                            }
                        }

                        // Recommendations
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Text("Recommendations")
                                    .font(.title3)
                                    .bold()

                                Spacer()

                                Picker("Sort", selection: $selectedSort) {
                                    ForEach(SortType.allCases, id: \.self) {
                                        Text($0.rawValue)
                                    }
                                }
                                .pickerStyle(.menu)
                                .padding(.trailing)
                            }
                            .padding(.horizontal)

                            LazyVStack(spacing: 16) {
                                ForEach(filteredArticles) { article in
                                    NavigationLink(
                                        destination: DetailScreen(articles: article, onDelete: {
                                            deleteArticle(article)
                                        })
                                    ) {
                                        NewsCardView(article: article)
                                            .background(.ultraThinMaterial)
                                            .cornerRadius(20)
                                            .shadow(color: .gray.opacity(0.3), radius: 10, x: 0, y: 5)
                                            .padding(.horizontal)
                                    }
                                }
                            }
                        }

                        Spacer(minLength: 40)
                    }
                    .padding(.top, 10)
                }
            }
            .onAppear {
                if !hasLoaded {
                    newsService.fetchArticles(for: topic)
                    hasLoaded = true
                }
            }
            .navigationBarHidden(true)
        }
        .navigationBarBackButtonHidden()
    }

    // Filtered Articles
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

    // Delete Article
    private func deleteArticle(_ article: Article) {
        withAnimation {
            newsService.articles.removeAll { $0 == article }
        }
    }
}

enum SortType: String, CaseIterable {
    case newest = "Newest"
    case oldest = "Oldest"
}
