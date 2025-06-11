//
//  SavedScreen.swift
//  NewsArticle
//
//  Created by Paranjothi iOS MacBook Pro on 11/06/25.
//

import SwiftUI
import CoreData

struct SavedScreen: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \SaveData.publishedAt, ascending: false)],
        animation: .default
    )
    private var savedArticles: FetchedResults<SaveData>

    var body: some View {
        List {
            ForEach(savedArticles) { article in
                VStack(alignment: .leading, spacing: 8) {
                    if let url = URL(string: article.urlToImage ?? "") {
                        AsyncImage(url: url) { phase in
                            if let image = phase.image {
                                image.resizable().aspectRatio(contentMode: .fill)
                                    .frame(height: 180).cornerRadius(10)
                            } else {
                                Color.gray.frame(height: 180).cornerRadius(10)
                            }
                        }
                    }

                    Text(article.title ?? "")
                        .font(.headline)

                    Text(article.descriptions ?? "")
                        .font(.subheadline)
                        .foregroundColor(.gray)

                    Text(article.publishedAt ?? "")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 8)
            }
        }
        .navigationTitle("Saved Articles")
    }
}

struct SavedArticleCard: View {
    let article: SaveData

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            AsyncImage(url: URL(string: article.urlToImage ?? "")) { phase in
                if let image = phase.image {
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

