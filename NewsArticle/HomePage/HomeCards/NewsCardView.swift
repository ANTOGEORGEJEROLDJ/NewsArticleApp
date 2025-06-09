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
        HStack(alignment: .top, spacing: 10){
            AsyncImage(url: URL(string: article.urlToImage ?? "")) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                }else{
                    Color.gray.opacity(0.3)
                }
            }
            .frame(width: 100, height: 80)
            .cornerRadius(8)
            .clipped()
            
            VStack(alignment: .leading, spacing: 6){
                Text(article.title)
                    .font(.headline)
                    .lineLimit(3)
                Text(formatDate(article.publishedAt))
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            Spacer()
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 3)
        
    }
    
    func formatDate(_ isoDate: String) -> String {
            let formatter = ISO8601DateFormatter()
            if let date = formatter.date(from: isoDate) {
                let displayFormatter = DateFormatter()
                displayFormatter.dateStyle = .medium
                displayFormatter.timeStyle = .short
                return displayFormatter.string(from: date)
            }
            return isoDate
    }
}

//#Preview {
//    NewsCardView()
//}
