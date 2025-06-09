
//
//  TopNewsCard.swift
//  NewsArticle
//
//  Created by Paranjothi iOS MacBook Pro on 09/06/25.
//

import SwiftUI

struct TopNewsCard: View {
    let article: Article

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            AsyncImage(url: URL(string: article.urlToImage ?? "")) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } else {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                }
            }
            .frame(width: 340, height: 195)
            .clipped()
            .cornerRadius(16)
            .shadow(radius: 4)

            VStack(alignment: .leading) {
                //                Text(article.title ?? "Unknown")
                //                    .font(.caption)
                //                    .bold()
                //                    .foregroundColor(.white.opacity(0.9))
                
                Text(article.title)
                    .font(.system(size: 15))
                    .bold()
                    .foregroundColor(.white)
                    .lineLimit(3)
                    .padding()
                    .padding(.top, 100)
            }
            .padding()
            .background(LinearGradient(colors: [.black.opacity(0.5), .clear], startPoint: .bottom, endPoint: .top))
            .cornerRadius(16)
        }
        .frame(width: 340)
        .padding(.vertical)
    }
}
