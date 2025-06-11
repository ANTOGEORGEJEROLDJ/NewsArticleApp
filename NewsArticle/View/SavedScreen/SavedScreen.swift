//
//  SavedScreen.swift
//  NewsArticle
//
//  Created by Paranjothi iOS MacBook Pro on 11/06/25.
//

import SwiftUI
import CoreData

struct SavedScreen: View {
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \SaveData.publishedAt, ascending: false)],
        animation: .default)
    private var savedArticles: FetchedResults<SaveData>

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(savedArticles) { article in
                        SavedArticleCard(article: article)
                    }
                }
                .padding()
            }
            .navigationTitle("Saved Articles")
        }
    }
}

struct SavedArticleCard: View {
    let article: SaveData

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            AsyncImage(url: URL(string: article.urlToImage ?? "")) { imagePhase in
                if let image = imagePhase.image {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 180)
                        .clipped()
                        .cornerRadius(10)
                } else {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 180)
                        .cornerRadius(10)
                }
            }

            Text(article.title ?? "")
                .font(.headline)
                .lineLimit(2)

            Text(article.descriptions ?? "")
                .font(.subheadline)
                .foregroundColor(.gray)
                .lineLimit(3)

            Text(article.publishedAt ?? "")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 3)
    }
}

#Preview {
    SavedScreen()
}
