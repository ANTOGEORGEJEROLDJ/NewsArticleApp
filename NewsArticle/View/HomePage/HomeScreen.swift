import SwiftUI

struct HomeScreen: View {
    var topic: String
    @Binding var isSignedIn: Bool
    @StateObject private var newsService = NewsService()
    @State private var selectedSort: SortType = .newest
    @State private var selectedCategory: String = "All"
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [.white.opacity(0.2), .white]),
                               startPoint: .top,
                               endPoint: .bottom)
                .ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        
                        // Header
                        HStack {
                            Button(action: {
                                dismiss()
                            }) {
                                Image("back")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 45, height: 45)
                                    .cornerRadius(15)
                                
                            }
                            
                            Spacer()
                            
                            Text("📰 Daily News")
                                .font(.system(size: 24, weight: .bold, design: .rounded))
                                .foregroundColor(.primary)
                            
                            Spacer()
                            NavigationLink(destination: ProfileScreen(username: "", email: "", isSignedIn: $isSignedIn)) {
                                Image(systemName: "person.circle.fill")
                                    .font(.largeTitle)
                                    .foregroundColor(.gray.opacity(0.7))
                            }
                        }
                        .padding(.horizontal)
                        
                        // Section: Breaking News
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Breaking News")
                                .font(.title3)
                                .bold()
                                .padding(.horizontal)
                            
                            if !newsService.articles.isEmpty {
                                TopNewsCarouselView(articles: Array(newsService.articles.prefix(5)))
                                    .transition(.slide)
                            }
                        }
                        
                        // Section: Sort & Recommend
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Text("Recommendations")
                                    .font(.title3)
                                    .bold()
                                
                                Spacer()
                                
                                Picker("Sort", selection: $selectedSort) {
                                    ForEach(SortType.allCases, id: \.self) {
                                        Text($0.rawValue)
                                    }
                                }
                                .pickerStyle(.menu)
                                .padding(.trailing)
                            }
                            .padding(.horizontal)
                            
                            LazyVStack(spacing: 16) {
                                ForEach(filteredArticles) { article in
                                    NavigationLink(destination: DetailScreen(articles: article)) {
                                        NewsCardView(article: article)
                                            .background(.ultraThinMaterial)
                                            .cornerRadius(20)
                                            .shadow(color: .gray.opacity(0.3), radius: 10, x: 0, y: 5)
                                            .padding(.horizontal)
                                        
                                    }
                                    .transition(.opacity)
                                }
                            }
                        }
                        
                        Spacer(minLength: 40)
                    }
                    .padding(.top, 10)
                    
                }
                .onAppear {
                    newsService.fetchArticles(for: topic)
                }
            }
            .navigationBarHidden(true)
        }
        .navigationBarBackButtonHidden()
    }
    
    var filteredArticles: [Article] {
        var filtered = newsService.articles
        if selectedCategory != "All" {
            filtered = filtered.filter { $0.title.lowercased().contains(selectedCategory.lowercased()) }
        }
        switch selectedSort {
        case .newest:
            filtered.sort { ($0.publishedAt ?? "") > ($1.publishedAt ?? "") }
        case .oldest:
            filtered.sort { ($0.publishedAt ?? "") < ($1.publishedAt ?? "") }
        }
        return filtered
    }
}

enum SortType: String, CaseIterable {
    case newest = "Newest"
    case oldest = "Oldest"
}
