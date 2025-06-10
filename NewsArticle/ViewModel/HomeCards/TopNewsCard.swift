
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
                        .fill(Color.white.opacity(0.3))
                        
                }
            }
            .frame(width: 350, height: 220)
            .background(.ultraThinMaterial)
            .clipped()
            .cornerRadius(16)
            .shadow(radius: 4)

            VStack(alignment: .leading) {
                
                Text(article.title)
                    .font(.system(size: 15))
                    .bold()
                    .foregroundColor(.white)
                    .lineLimit(3)
                    .padding()
                    .padding(.top, 100)
            }
            .padding()
//            .background(LinearGradient(colors: [.black.opacity(0.5), .clear], startPoint: .bottom, endPoint: .top))
            .cornerRadius(16)
        }
        .frame(width: 350)
        .padding(.vertical)
    }
}
