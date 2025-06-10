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
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            Color(UIColor.systemGroupedBackground).ignoresSafeArea()
            
            VStack {
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
                    .padding(.leading, 20)
                    
                    Text(selectedTopic ?? "Choose Topic")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.horizontal, 60)
                        
                    
                    Spacer()
                }
                .padding(.top, 20)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        ForEach(newsItems, id: \.0) { item in
                            Button(action: {
                                selectedTopic = item.0
                            }) {
                                APIselectedCard(title: item.0, imageName: item.1)
                                    .padding(.horizontal)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 19)
                                            .stroke(selectedTopic == item.0 ? Color.orange : Color.clear, lineWidth: 3)
                                            .frame(width: 345)
                                    )
                            }
                        }
                        Spacer(minLength: 10)
                    }
                    .padding(.top, 20)
                }
                .padding(.top, -20)
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
                            Text("Continue")
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
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    SelectNewsScreen()
}
