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
        ZStack(alignment: .leading){
            AsyncImage(url: URL(string: article.urlToImage ?? "")) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                }else{
                    Color.gray.opacity(0.2)
                }
                        
            }
            .scaledToFit()
            .frame(height: 190)
            .clipped()
            .cornerRadius(20)
            
            Text(article.title)
                .padding()
                .padding(.top, 100)
                .foregroundColor(.white)
                .font(.subheadline)
                .bold()
                .lineLimit(3)
                .frame(width: 300, alignment: .leading)
        }
        .frame(width: 300)
        .background(Color.white.opacity(0.5))
        .cornerRadius(20)
        .shadow(radius: 2)
    }
}

