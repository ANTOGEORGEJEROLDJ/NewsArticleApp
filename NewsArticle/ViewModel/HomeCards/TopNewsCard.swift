
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
        
        ZStack(alignment: .leading) {
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

            Text(article.title)
                .font(.system(size: 15))
                .bold()
                .foregroundColor(.white)
                .lineLimit(3)
                .padding()
                .padding(.top, 100)
        }
        .frame(width: 340)
        .padding()
        .background(.white)
        .cornerRadius(20)
        
    }
}
