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
                                    .frame(width: 400, height: 350)
                                    .cornerRadius(30, corners: [.bottomLeft, .bottomRight])
                                    .shadow(radius: 10)
                                    .aspectRatio(contentMode: .fill)
                            } else {
                                Color.gray.opacity(0.2)
                            }
                        }
                        .frame(height: 300)
                        .frame(maxWidth: .infinity)
                        .clipped()
                        .cornerRadius(15)
                        
                        Text(articles.title)
                            .font(.title2)
                            .bold()
                            .foregroundColor(.white)
                            .padding()
                            
                            .cornerRadius(10)
                            .padding()
                    }
                    
                    // 🔷 Article metadata and description
                    VStack( spacing: 12) {
                        
                        Group{
                            Text("Published At:")
                                .font(.headline)
                                .padding(.horizontal,-183)
                                .padding(.top,-150)
                            Text(articles.publishedAt)
                                .foregroundColor(.gray)
                                .padding(.horizontal,-183)
                                .padding(.top,-125)
                            
                            Text("Description:")
                                .font(.headline)
                                .padding(.horizontal,-183)
                                .padding(.top,-100)
                                
                            Text(articles.description)
                                .lineLimit(100)
                                .padding(.top,-80)
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
        .navigationTitle("Detail")
        .navigationBarTitleDisplayMode(.inline)
    }
    
}
#Preview {
    NavigationView {
        DetailScreen(articles: sampleArticle)
    }
}
let sampleArticle = Article(
    title: "Alexander wears modified helmet in road races",
    urlToImage: "https://picsum.photos/600/400",
    publishedAt: "2025-06-08T08:35:09Z",
    description: """
As a tech department, we're usually pretty good at spotting tech that's out of the ordinary. During time trials we're used to seeing new aero innovation, and while there are certainly aero tricks used in road stages, they are harder to spot.

A case in point, throughout the Volta ao Algarve, Alexander Kristoff has been wearing an old discontinued time trial helmet...
""",
    author: "CNN Indonesia"
)

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
