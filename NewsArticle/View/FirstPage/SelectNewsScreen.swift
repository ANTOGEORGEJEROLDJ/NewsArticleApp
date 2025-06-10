//
//  SelectNewsScreen.swift
//  NewsArticle
//
//  Created by Paranjothi iOS MacBook Pro on 10/06/25.
//

import SwiftUI

struct SelectNewsScreen: View {
    let newsItems = [
        ("Apple News", "apple"),
        ("Business News", "business"),
        ("Tesla News", "tesla"),
        ("TechCrunch", "techcrunch"),
        ("Wall Street Journal", "WallStreetJournal")
    ]

    @State private var selectedTopic: String? = nil
    @State private var navigateToHome = false

    var body: some View {
        NavigationView {
            ZStack {
                Color(UIColor.systemGroupedBackground).ignoresSafeArea()

                VStack {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 20) {
                            Text("Selected Topics")
                                .font(.title2)
                                .fontWeight(.bold)
                                .padding(.horizontal)

                            ForEach(newsItems, id: \.0) { item in
                                Button(action: {
                                    selectedTopic = item.0
                                }) {
                                    APIselectedCard(title: item.0, imageName: item.1)
                                        .padding(.horizontal)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 19)
                                                .stroke(selectedTopic == item.0 ? Color.orange : Color.clear, lineWidth: 3)
                                                .frame(width: 370)
                                        )
                                }
                            }

                            Spacer(minLength: 10)
                        }
                        .padding(.top, -60)
                    }

                    // Navigate Button
                    NavigationLink(
                        destination: TapView(topic: selectedTopic ?? "Apple News"),
                        isActive: $navigateToHome,
                        label: {
                            Button(action: {
                                if selectedTopic != nil {
                                    navigateToHome = true
                                }
                            }) {
                                Text("Navigate")
                                    .foregroundColor(.black)
                                    .font(.headline)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.orange.opacity(0.7))
                                    .cornerRadius(12)
                                    .padding(.horizontal)
                                    .padding(.bottom, 10)
                            }
                        })

                }
            }
            .navigationTitle("Choose Topic")
        }
    }
}

#Preview {
    SelectNewsScreen()
}
