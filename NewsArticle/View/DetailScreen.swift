//
//  DetailScreen.swift
//  NewsArticle
//
//  Created by Paranjothi iOS MacBook Pro on 09/06/25.
//

import SwiftUI

struct DetailScreen: View {
    
    let articles: Article
    
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    
                    // 🔷 Image with title overlay
                    ZStack(alignment: .bottomLeading) {
                        AsyncImage(url: URL(string: articles.urlToImage ?? "")) { phase in
                            if let image = phase.image {
                                image
                                    .resizable()
                                    .frame(width: 410, height: 400)
                                    .cornerRadius(30, corners: [.bottomLeft, .bottomRight])
                                    .shadow(radius: 10)
                                    .aspectRatio(contentMode: .fill)
                            } else {
                                Color.gray.opacity(0.2)
                            }
                        }
                        .frame(height: 400)
                        .frame(maxWidth: .infinity)
                        .clipped()
                        .cornerRadius(20)
                        
                        Text(articles.title)
                            .font(.subheadline)
                            .bold()
                            .foregroundColor(.white)
                            .padding()
                            .cornerRadius(10)
                            .padding(.bottom,1)
                            
                    }
                    
                    // 🔷 Article metadata and description
                    VStack( spacing: 12) {
                        
                        Group{
                            Text("Published At:")
                                .font(.headline)
                                .padding(.horizontal,-183)
                                .padding(.top,-185)
                            Text(articles.publishedAt!)
                                .foregroundColor(.gray)
                                .padding(.horizontal,-183)
                                .padding(.top,-160)
                            
                            Text("Description:")
                                .font(.headline)
                                .padding(.horizontal,-183)
                                .padding(.top,-125)
                                
                            Text(articles.description!)
                                .lineLimit(10)
                                .padding(.top,-100)
                            
                        }
                    }
                    .padding()
                    .frame(width: 400,height: 500)
                    .background(Color.white)
                    .cornerRadius(12)
                    
                }
                .padding()
            }
        }
//        .navigationTitle("Detail")
//        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            print("-----> \(articles.description ?? "No Description")")
        }
    }
    
}


// MARK: - Corner Radius Extension
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}
