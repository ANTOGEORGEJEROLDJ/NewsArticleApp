//
//  TapView.swift
//  NewsArticle
//
//  Created by Paranjothi iOS MacBook Pro on 09/06/25.
//

import SwiftUI

struct TapView: View {
    @State private var selectedTab: Tab = .home

    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                switch selectedTab {
                case .home:
                    HomeScreen()
                case .search:
                    SearchScreen()
                }

                Spacer()
                
                FloatingTabBar(selectedTab: $selectedTab)
                    .padding(.bottom, 20)
            }
        }
    }

    // MARK: - Enum for Tab
    enum Tab {
        case home, search
    }
}

// MARK: - Floating Tab Bar
struct FloatingTabBar: View {
    @Binding var selectedTab: TapView.Tab

    var body: some View {
        HStack(spacing: 150) {
            TabBarButton(icon: "house.fill", tab: .home, selectedTab: $selectedTab, color: .orange)
            
            TabBarButton(icon: "magnifyingglass", tab: .search, selectedTab: $selectedTab, color: .orange)
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(40)
        .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
        .padding(.horizontal)
    }
}

// MARK: - Tab Button
struct TabBarButton: View {
    let icon: String
    let tab: TapView.Tab
    @Binding var selectedTab: TapView.Tab
    var color: Color

    var body: some View {
        Button(action: {
            withAnimation(.easeInOut) {
                selectedTab = tab
            }
        }) {
            Image(systemName: icon)
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(selectedTab == tab ? color : .gray)
                .padding(12)
                .background(
                    Circle()
                        .fill(selectedTab == tab ? color.opacity(0.2) : Color.clear)
                )
        }
    }
}
