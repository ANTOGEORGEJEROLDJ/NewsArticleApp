//
//  SelectNewsScreen.swift
//  NewsArticle
//
//  Created by Paranjothi iOS MacBook Pro on 10/06/25.
//  Updated and corrected on 10/06/25
//

import SwiftUI

struct SelectNewsScreen: View {
    // News items with display name and API topic
    let newsItems = [
        ("Apple News", "apple"),
        ("Business News", "business"),
        ("Tesla News", "tesla"),
        ("TechCrunch", "techcrunch"),
        ("Wall Street Journal", "WallStreetJournal")
    ]

    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    @State private var selectedTopic: String? = nil
    @State private var navigateToHome = false
    @State private var showNoTopicAlert = false
    
    // Parameters passed from SIgnInScreen
    let username: String
    let email: String

    var body: some View {
        ZStack {
            // Gradient Background
            LinearGradient(
                gradient: Gradient(colors: [.orange.opacity(0.1), .white]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack {
                // Header
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
                        .font(.system(size: 15))
                        .bold()
                        .fontWeight(.bold)
                        .padding(.horizontal, 70)
                    
                    
                    Spacer()
                }
                .padding(.top, 20)
                
                // News Selection Cards
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        ForEach(newsItems, id: \.0) { item in
                            Button(action: {
                                withAnimation(.spring()) {
                                    selectedTopic = item.1 // Use API topic
                                }
                            }) {
                                APIselectedCard(title: item.0, imageName: item.1)
                                    .padding(.horizontal)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 19)
                                            .stroke(selectedTopic == item.1 ? Color.orange : Color.clear, lineWidth: 3).frame(width: 347)
                                    )
                            }
                        }
                        Spacer(minLength: 20)
                    }
                    .padding(.top, 8)
                }
                
                // Continue Button
                NavigationLink(
                    destination: TapView(
                        topic: selectedTopic ?? "apple",
                        username: username,
                        email: email
                    )
                    .environment(\.managedObjectContext, viewContext),
                    isActive: $navigateToHome
                ) {
                    Button(action: {
                        if selectedTopic != nil {
                            navigateToHome = true
                        } else {
                            showNoTopicAlert = true
                        }
                    }) {
                        Text("Continue")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .bold()
                            .background(Color.orange.opacity(0.7))
                            .foregroundColor(.black.opacity(0.7))
                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
                .alert(isPresented: $showNoTopicAlert) {
                    Alert(
                        title: Text("No Topic Selected"),
                        message: Text("Please select a news topic to continue."),
                        dismissButton: .default(Text("OK"))
                    )
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}



struct SelectNewsScreen_Previews: PreviewProvider {
    static var previews: some View {
        SelectNewsScreen(username: "JohnDoe", email: "john.doe@example.com")
    }
}
