//
//  NewsCardView.swift
//  NewsArticle
//
//  Created by Paranjothi iOS MacBook Pro on 09/06/25.
//

import SwiftUI

struct NewsCardView: View {
    let article: Article
    @State private var isLiked = false  // 🩷 Track like state
    @State private var showComments = false  // 💬 Track comment tap

    var body: some View {
        ZStack {
            // Background card
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(UIColor.white).opacity(0.8))

            VStack(spacing: 12) {
                HStack(alignment: .top, spacing: 16) {
                    // 🖼 Image
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

                    // 📰 Details
                    VStack(alignment: .leading, spacing: 6) {
                        Text(article.title ?? "No Title")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                            .lineLimit(2)

                        if let date = article.publishedAt {
                            Text(date.prefix(10))
                                .font(.caption)
                                .foregroundColor(.gray)
                                .padding(.top, 4)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }

                // ❤️‍🔥 Like & 💬 Comment Buttons
                HStack {
                    Button(action: {
                            isLiked.toggle()
                        }) {
                            Image(systemName: isLiked ? "heart.fill" : "heart")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 27, height: 27) // ✅ Resize the heart icon only
                                .foregroundColor(isLiked ? .red : .gray)
                                .padding(10)
                                .clipShape(Circle())
                        }

                        // Optional: You can add a label next to it
                        Text("Like")
                            .font(.subheadline)
                            .foregroundColor(.primary)

                    Spacer()

                    Button(action: {
                        showComments.toggle()
                    }) {
                        Label("Comment", systemImage: "bubble.right")
                            .foregroundColor(.blue)
                            .font(.subheadline)
                    }
                }
                .padding(.horizontal)
            }
            .padding()
        }
        .padding(.horizontal)
        .padding(.vertical, 6)
        .background(.white.opacity(0.8))
        .cornerRadius(20)
        .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 3)

        // Optional: Show comment screen on tap
//        .sheet(isPresented: $showComments) {
//            CommentScreen(article: article) // You'll need to create this
//        }
    }
}
