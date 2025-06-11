//
//  APIselectedCard.swift
//  NewsArticle
//
//  Created by Paranjothi iOS MacBook Pro on 10/06/25.
//

import SwiftUI

struct APIselectedCard: View {
    let title: String
    let imageName: String

    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
                .foregroundColor(.black)
                .padding(.leading, 10)

            Spacer()

            Image(imageName)
                .resizable()
                .scaledToFit()
                .cornerRadius(19)
                .frame(width: 150, height: 120)
                .padding(.trailing, 10)
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 120)
        .background(Color.white)
        .cornerRadius(19)
        .shadow(color: .gray.opacity(0.3), radius: 6, x: 0, y: 4)
    }
}

#Preview {
    APIselectedCard(title: "Tesla News", imageName: "tesla")
}
