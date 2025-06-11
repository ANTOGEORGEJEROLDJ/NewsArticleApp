
//
//  CustomTabView.swift
//  NewsArticle
//
//  Created by Paranjothi iOS MacBook Pro on 09/06/25.
//  Updated and corrected on 10/06/25
//

import SwiftUI

struct TapView: View {
    var topic: String
    var username: String
    var email: String
    @State private var selectedTab: Tab = .home
    @State static var isSignedIn = false

    enum Tab {
        case home
        case search
        case profile
        case savedscreens
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            // Content View
            VStack {
                switch selectedTab {
                case .home:
                    HomeScreen(topic: topic, isSignedIn: TapView.$isSignedIn)
                case .search:
                    SearchScreen()
                case .savedscreens:
                    SavedScreen()
                case .profile:
                    ProfileScreen(username: username, email: email, isSignedIn: TapView.$isSignedIn)
                }
            }
            .ignoresSafeArea(.keyboard)

            // Floating Tab Bar
            FloatingTabBar(selectedTab: $selectedTab)
                .padding(.bottom, 10)
        }
        .navigationBarBackButtonHidden()
        .background(Color.clear.ignoresSafeArea())
    }
}

struct FloatingTabBar: View {
    @Binding var selectedTab: TapView.Tab

    var body: some View {
        HStack(spacing: 50) {
            TabBarButton(icon: "house.fill", tab: .home, selectedTab: $selectedTab, color: .orange)
            TabBarButton(icon: "magnifyingglass", tab: .search, selectedTab: $selectedTab, color: .orange)
            TabBarButton(icon: "square.and.arrow.down.fill", tab: .savedscreens, selectedTab: $selectedTab, color: .orange)
            TabBarButton(icon: "person.fill", tab: .profile, selectedTab: $selectedTab, color: .orange)
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 20)
        .frame(width: 300)
        .background(
            Color(UIColor.systemBackground).opacity(0.95)
                .clipShape(Capsule())
                .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 4)
        )

        .padding(.horizontal)
    }
}

struct TabBarButton: View {
    let icon: String
    let tab: TapView.Tab
    @Binding var selectedTab: TapView.Tab
    let color: Color

    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                selectedTab = tab
                
            }
            
        }) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(selectedTab == tab ? color : .gray)
                .padding(12)
                .background(
                    Circle()
                        .fill(selectedTab == tab ? color.opacity(0.2) : .clear)
                        .scaleEffect(selectedTab == tab ? 1.2 : 1.0)
                )
                .scaleEffect(selectedTab == tab ? 1.1 : 1.0)
                
        }
        .frame(width: 25)
    }
}

// Placeholder SearchScreen (replace with your actual implementation)
struct SearchsScreen: View {
    var body: some View {
        VStack {
            Text("Search News")
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundColor(.black)
            Spacer()
        }
        .navigationBarHidden(true)
    }
}

struct CustomTabView_Previews: PreviewProvider {
    static var previews: some View {
        TapView(topic: "technology", username: "JohnDoe", email: "john.doe@example.com")
    }
}
