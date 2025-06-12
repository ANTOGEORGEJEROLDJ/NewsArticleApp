//
//  DetailScreen.swift
//  NewsArticle
//
//  Created by Paranjothi iOS MacBook Pro on 09/06/25.
//

import SwiftUI
import CoreData

struct DetailScreen: View {
    let articles: Article
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var isSave = false
    
    var onDelete: (() -> Void)?
    
    @State private var showDeleteAlert = false
    @State private var showSaveConfirmation = false
    @State private var showShareSheet = false
    
    var body: some View {
        ZStack {
            Color(UIColor.systemBackground).ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    // Back & Header
                    HStack {
                        Button(action: {
                            dismiss()
                        }) {
                            Image("back")
                                .resizable()
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
                    .padding(.top, -20)
                    
                    // News Image
                    ZStack(alignment: .bottom) {
                        AsyncImage(url: URL(string: articles.urlToImage ?? "")) { phase in
                            if let image = phase.image {
                                image
                                    .resizable()
                                    .frame(width: 410, height: 300)
                                    .cornerRadius(60, corners: [.bottomLeft, .bottomRight])
                            } else {
                                Color.gray.opacity(0.2)
                            }
                        }
                        
                        Text(articles.title)
                            .font(.system(size: 10))
                            .bold()
                            .foregroundColor(.white)
                            .padding()
                    }
                    
                    // Save, Share & Delete buttons horizontally
                    HStack {
                        // Delete
                        Button(action: {
                            showDeleteAlert = true
                        }) {
                            Image(systemName: "trash")
                                .font(.title)
                                .foregroundColor(.red)
                                .padding()
                        }
                        .alert("Delete this article?", isPresented: $showDeleteAlert) {
                            Button("Delete", role: .destructive) {
                                onDelete?()
                                dismiss()
                            }
                            Button("Cancel", role: .cancel) {}
                        }
                        .padding(.leading, 10)
                        
                        Spacer()
                        
                        // Save
                        Button(action: {
                            saveArticles()
                            isSave.toggle()
                            }) {
                                Image("saveIcon")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 27, height: 27) // ✅ Resize the heart icon only
                                    .foregroundColor(isSave ? .red : .gray)
                                    .padding(10)
                                    .clipShape(Circle())
                            }
                        
                        .alert("Saved to bookmarks!", isPresented: $showSaveConfirmation) {
                            Button("OK", role: .cancel) {}
                        }
                        
                        
                        
                        // Share
                        Button(action: {
                            showShareSheet = true
                        }) {
                            Image("shareIcon")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 29, height: 29) // ✅ Resize the heart icon only
                                .padding(10)
                                .clipShape(Circle())
                                .padding(.trailing, 20)
                        }
                        
                        
                    }
                    
                    // Article Metadata
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Published At:")
                            .font(.headline)
                        Text(formattedDate(from: articles.publishedAt))
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        Text("Description:")
                            .font(.headline)
                            .padding(.top, 10)
                        
                        Text(articles.description ?? "")
                            .lineLimit(10)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                }
                .padding()
            }
        }
        .navigationBarBackButtonHidden()
        .sheet(isPresented: $showShareSheet) {
            ShareSheet(items: [
                articles.title,
                articles.description ?? "",
                URL(string: articles.urlToImage ?? "") as Any
            ])
        }
    }
    
    // Format ISO date string to readable format
    func formattedDate(from isoString: String?) -> String {
        guard let isoString = isoString else { return "Unknown date" }
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        let fallbackFormatter = ISO8601DateFormatter()
        let date = isoFormatter.date(from: isoString) ?? fallbackFormatter.date(from: isoString)
        guard let validDate = date else { return "Invalid date" }
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        return formatter.string(from: validDate)
    }
    
    // Save article to Core Data and show confirmation alert
    func saveArticles() {
        let savedArticle = SaveData(context: viewContext)
        savedArticle.title = articles.title ?? "No Title"
        savedArticle.descriptions = articles.description ?? "No Description"
        savedArticle.urlToImage = articles.urlToImage ?? ""
        savedArticle.publishedAt = articles.publishedAt ?? "Unknown Date"

        do {
            try viewContext.save()
            print("✅ Article saved")
            showSaveConfirmation = true
        } catch {
            print("❌ Failed to save: \(error)")
        }
    }
}

// MARK: - Corner Radius Extension for specific corners
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

//// MARK: - ShareSheet View
//struct ShareSheet: UIViewControllerRepresentable {
//    var activityItems: [Any]
//    var applicationActivities: [UIActivity]? = nil
//
//    func makeUIViewController(context: Context) -> UIActivityViewController {
//        UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
//    }
//
//    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
//}
//
//// MARK: - Preview
//struct DetailScreen_Previews: PreviewProvider {
//    static var previews: some View {
//        let mockArticle = Article(
//            title: "Sample News Article",
//            urlToImage: "https://via.placeholder.com/350",
//            publishedAt: "2025-06-09T13:45:00Z",
//            description: "This is a sample description for the news article, providing details about the topic.",
//            author: ""
//        )
//        
//        DetailScreen(articles: mockArticle)
//            .previewDisplayName("Detail Screen")
//            .preferredColorScheme(.light)
//    }
//}
