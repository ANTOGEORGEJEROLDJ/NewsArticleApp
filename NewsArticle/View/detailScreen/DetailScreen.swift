//
//  DetailScreen.swift
//  NewsArticle
//
//  Created by Paranjothi iOS MacBook Pro on 09/06/25.
//

import SwiftUI

struct DetailScreen: View {
    
    let articles: Article
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            Color(UIColor.systemBackground)
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {
                    
                    HStack {
                        Button(action: {
                            dismiss()  // Navigate back to the previous screen
                        }) {
                            Image("back")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 45, height: 45)
                                .cornerRadius(15)
                        }
                        .padding(.leading, 30)
                        
                        Text("Detail page")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.horizontal, 50)
                            
                        
                        Spacer()
                    }.padding()
                    .padding(.top, -20)
                    
                    
                    // 🔷 Image with title overlay
                    ZStack(alignment: .bottomLeading) {
                        AsyncImage(url: URL(string: articles.urlToImage ?? "")) { phase in
                            if let image = phase.image {
                                image
                                    .resizable()
                                    .frame(width: 450, height: 400)
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
                            .padding(.leading,20)
                        
                    }.padding(.top, -20)
                    
                    // 🔷 Article metadata and description
                    VStack( spacing: 12) {
                        
                        Group{
                            Text("Published At:")
                                .font(.headline)
                                .padding(.horizontal,-183)
                                .padding(.top,-185)
                                .padding(.leading, 20)
                            Text(formattedDate(from: articles.publishedAt))
                                .font(.caption)
                                .foregroundColor(.gray)
                                .padding(.horizontal, -183)
                                .padding(.top, -160)
                                .padding()
                            
                            
                            Text("Description:")
                                .font(.headline)
                                .padding(.horizontal,-183)
                                .padding(.top,-130)
                                .padding()
                            
                            Text(articles.description ?? "")
                                .lineLimit(10)
                                .padding(.top,-110)
                                .padding()
                            
                        }
                    }
                    .padding()
                    .frame(width: 400,height: 500)
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(12)
                    
                }
                .padding()
            }
        
        }.navigationBarBackButtonHidden()

        .onAppear {
            print("-----> \(articles.description ?? "No Description")")
        }
    }
    
    /// 🔧 Helper function
    func formattedDate(from isoString: String?) -> String {
        guard let isoString = isoString else { return "Unknown date" }

        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        let fallbackFormatter = ISO8601DateFormatter() // In case without fractional seconds

        let date: Date? = isoFormatter.date(from: isoString) ?? fallbackFormatter.date(from: isoString)

        guard let validDate = date else { return "Invalid date" }

        let formatter = DateFormatter()
        formatter.dateStyle = .long        // e.g., June 9, 2025
        formatter.timeStyle = .short       // e.g., 1:45 PM

        return formatter.string(from: validDate)
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
