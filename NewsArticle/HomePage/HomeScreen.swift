//
//  ContentView.swift
//  NewsArticle
//
//  Created by Paranjothi iOS MacBook Pro on 09/06/25.
//



import SwiftUI

struct HomeScreen: View {
    @StateObject private var newsService = NewsService()
    @State private var searchedArticle: [Article] = []
    
    var body: some View {
    
        NavigationView {
            ZStack {
                Color.white
                    .ignoresSafeArea()
                
                ScrollView{
                VStack(spacing: 0) {
                    
                    HStack {
                        Image(systemName: "newspaper")
                            .font(.title)
                            .foregroundColor(.blue)
                        Text("Breaking New")
                            .font(.title2)
                            .bold()
                        Spacer()
                        
                        Text("View all")
                            .font(.caption)
                            .bold()
                            .foregroundColor(.blue)
                    }
                    .padding()
                    
                    Spacer()
                    
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack (spacing: 16){
                            ForEach(newsService.articles.prefix(5)){ article in
                                TopNewsCard(article: article)
                            }
                        }
                    }
                    .padding()
                    Spacer()
                    
                    HStack {
                        
                        Text("Reccomendation")
                            .font(.title2)
                            .bold()
                        Spacer()
                        
                        Text("view all")
                            .font(.caption)
                            .bold()
                            .foregroundColor(.blue)
                    }
                    .padding()
                    
                    
                    
                    // News List
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(newsService.articles) { article in
                                NavigationLink(destination: DetailScreen(articles: article)){
                                    NewsCardView(article: article)
                                }
                            }.shadow(radius: 2, x: 0, y: -2)
                        }
                        .padding(.horizontal)
//
                    }.padding(.top)
                    
                }
                .navigationBarHidden(true)
                .onAppear {
                    newsService.fetchArticles()
                }
            }
        }
        }
    }
}

#Preview {
    HomeScreen()
}


