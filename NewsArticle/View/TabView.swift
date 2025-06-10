//
//  TapView.swift
//  NewsArticle
//
//  Created by Paranjothi iOS MacBook Pro on 09/06/25.
//

import SwiftUI

struct TapView: View {
    var topic: String
    @State private var selectedTab: Tab = .home

    var body: some View {
        ZStack(alignment: .bottom) {
            Group {
                switch selectedTab {
                case .home:
                    HomeScreen(topic: topic)
                case .search:
                    SearchScreen()
                }
            }

            FloatingTabBar(selectedTab: $selectedTab)
                .padding(.bottom, -10)
        }.navigationBarBackButtonHidden()
        .background(Color.clear.ignoresSafeArea())
    }

    enum Tab {
        case home, search
    }
}

struct FloatingTabBar: View {
    @Binding var selectedTab: TapView.Tab

    var body: some View {
        HStack(spacing: 100) {
            TabBarButton(icon: "house.fill", tab: .home, selectedTab: $selectedTab, color: .orange)
            TabBarButton(icon: "magnifyingglass", tab: .search, selectedTab: $selectedTab, color: .orange)
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .clipShape(Capsule())
        .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 4)
        .padding(.horizontal)
    }
}

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
                .padding(10)
                .background(
                    Circle()
                        .fill(selectedTab == tab ? color.opacity(0.2) : Color.clear)
                )
        }
    }
}
