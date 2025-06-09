//
//  NewsCardView.swift
//  NewsArticle
//
//  Created by Paranjothi iOS MacBook Pro on 09/06/25.
//

import SwiftUI

struct NewsCardView: View {
    let article: Article

    var body: some View {
        ZStack {
            // Background card
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(UIColor.secondarySystemBackground))
//                .shadow(color: .gray.opacity(0.3), radius: 8, x: 0, y: 4)
                .shadow(radius: 5)

            HStack(alignment: .top, spacing: 16) {
                // 🖼 Image with fallback
                if let imageUrl = article.urlToImage,
                   let url = URL(string: imageUrl) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 100, height: 100)
                                .clipped()
                                .cornerRadius(12)
                        case .failure(_):
                            Image(systemName: "photo.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .foregroundColor(.gray)
                        default:
                            ProgressView()
                                .frame(width: 100, height: 100)
                        }
                    }
                }

                // 📰 Article details
                VStack(alignment: .leading, spacing: 6) {
                    Text(article.title ?? "No Title")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                        .lineLimit(2)



                    if let date = article.publishedAt {
                        Text(date.prefix(10)) // e.g., 2025-06-09
                            .font(.caption)
                            .foregroundColor(.gray)
                            .padding(.top, 4)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding()
        }
        .padding(.horizontal)
        .frame(maxWidth: .infinity)
        .padding(.vertical, 6)
    }
}
