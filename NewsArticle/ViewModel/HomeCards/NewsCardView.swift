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
        HStack(alignment: .top, spacing: 16) {
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
                    default:
                        ProgressView()
                            .frame(width: 100, height: 100)
                    }
                }
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text(article.title ?? "No Title")
                    .font(.headline)
                    .lineLimit(2)
                
                Text(article.description ?? "No Description")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .lineLimit(2)
                
                if let date = article.publishedAt {
                    Text(date.prefix(10)) // Just the date part
                        .font(.caption)
                        .foregroundColor(.blue)
                }
            }
        }
        .padding(.vertical, 8)
    }
}
