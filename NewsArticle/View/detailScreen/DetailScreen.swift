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
    @Environment(\.managedObjectContext) private var viewContext

    
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
                        .padding(.leading, 17)
                        
                        Text("Detail page")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.horizontal, 60)
                            
                        Spacer()
                    }
                    .padding()
                    .padding(.top, -20)
                    .background(Color.clear)
                    
                    // 🔷 Image with title overlay
                    ZStack(alignment: .bottom) {
                        AsyncImage(url: URL(string: articles.urlToImage ?? "")) { phase in
                            if let image = phase.image {
                                image
                                    .resizable()
                                    .frame(width: 410, height: 300)
                                    .cornerRadius(60, corners: [.bottomLeft, .bottomRight])
                                    .aspectRatio(contentMode: .fill)
                            } else {
                                Color.gray.opacity(0.2)
                            }
                        }
                        .clipped()
                        
                        Text(articles.title)
                            .font(.system(size: 10))
                            .bold()
                            .foregroundColor(.white)
                            .padding()
                            .cornerRadius(10)
                            .padding(.bottom, 1)
                            .padding(.leading, 10)
                    }
                    .padding(.top, -20)
                    
                    HStack {
                        Spacer()
                        Image("saveIcon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 45, height: 45)
                            .cornerRadius(15)
                            .onTapGesture {
                                saveArticles()
                            }

                        
                        Image("shareIcon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 42, height: 45)
                            .cornerRadius(15)
                            .padding(.trailing, 40)
                        
                    }.padding(.top, -45)
                    
                    // 🔷 Article metadata and description
                    VStack(spacing: 12) {
                        Group {
                            Text("Published At:")
                                .font(.headline)
                                .padding(.horizontal, -183)
                                .padding(.top, -165)
                            Text(formattedDate(from: articles.publishedAt))
                                .font(.caption)
                                .foregroundColor(.gray)
                                .padding(.horizontal, -160)
                                .padding(.top, -160)
                                .padding()
                            
                            Text("Description:")
                                .font(.headline)
                                .padding(.horizontal, -183)
                                .padding(.top, -150)
                                .padding()
                            
                            Text(articles.description ?? "")
                                .lineLimit(10)
                                .padding(.top, -150)
                                .padding()
                        }
                    }
                    .padding()
                    .frame(width: 400, height: 400)
                    .background(Color.white)
                    .cornerRadius(12)
                }
                .padding()
            }
        }
        .navigationBarBackButtonHidden()
        .onAppear {
            print("-----> \(articles.description ?? "No Description")")
        }
    }
    
    /// 🔧 Helper function
    func formattedDate(from isoString: String?) -> String {
        guard let isoString = isoString else { return "Unknown date" }

        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        let fallbackFormatter = ISO8601DateFormatter()

        let date: Date? = isoFormatter.date(from: isoString) ?? fallbackFormatter.date(from: isoString)

        guard let validDate = date else { return "Invalid date" }

        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short

        return formatter.string(from: validDate)
    }
    
    func saveArticles() {
        let savedArticle = SaveData(context: viewContext)
        savedArticle.title = articles.title ?? "No Title"
        savedArticle.descriptions = articles.description ?? "No Description"
        savedArticle.urlToImage = articles.urlToImage ?? ""
        savedArticle.publishedAt = articles.publishedAt ?? "Unknown Date"

        do {
            try viewContext.save()
            print("✅ Article saved")
        } catch {
            let nsError = error as NSError
            print("❌ Failed to save: \(nsError), \(nsError.userInfo)")
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

// MARK: - Preview Provider
struct DetailScreen_Previews: PreviewProvider {
    static var previews: some View {
        // Mock Article for preview
        let mockArticle = Article(
            title: "Sample News Article",
            urlToImage: "This is a sample description for the news article, providing details about the topic.",
            publishedAt: "https://via.placeholder.com/350", // Sample image URL
            description: "2025-06-09T13:45:00Z", author: "" // Sample ISO 8601 date
        )
        
        DetailScreen(articles: mockArticle)
            .previewDisplayName("Detail Screen")
            .preferredColorScheme(.light) // Optional: Test in light mode
    }
}
