//
//  SIgnInScreen.swift
//  NewsArticle
//
//  Created by Paranjothi iOS MacBook Pro on 10/06/25.
//

import SwiftUI

struct SIgnInScreen: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var UserName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var navigationToSelectNewsScreen = false
    
    var body: some View {
            ScrollView {
                VStack {
                    Image("loginImage")
                        .resizable()
                        .scaledToFill()
                    
                        .frame(width: 175, height: 175)
                        .padding(.top)
                    Text("Login to continue")
                        .padding()
                        .font(.headline)
                        .foregroundColor(.black.opacity(0.5))
                }
                .padding(.top)
                
                Group {
                    VStack(spacing: 20) {
                        CustomTextField(icon: "person.fill", placeHolder: "UserName", text: $UserName)
                        CustomTextField(icon: "envelope.fill", placeHolder: "Mail", text: $email)
                        CustomTextField(icon: "lock.fill", placeHolder: "Password", text: $password)
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(20)
                    .shadow(radius: 2)
                    .padding(.horizontal)
                    .padding(.top, 20)
                }
                
                Spacer()
                VStack(spacing: 20) {
                    // NavigationLink to TabView
                    NavigationLink(
                        destination: SelectNewsScreen(username: "", email: "")
                            .environment(\.managedObjectContext, viewContext),
                        isActive: $navigationToSelectNewsScreen
                    ) {
                        EmptyView()
                    }
                    
                    // Login Button
                    Button(action: {
                        navigationToSelectNewsScreen = true // Trigger navigation
                    }) {
                        Text("Login")
                            .frame(width: 258, height: 22)
                            .padding()
                            .bold()
                            .background(Color.orange.opacity(0.4))
                            .foregroundColor(.black.opacity(0.7))
                            .font(.headline)
                            .cornerRadius(15)
                            .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)
                    }
                    .padding(.top, -30)
                    
                    HStack(spacing: 20) {
                        Button(action: {
                            // Google sign-in action
                        }) {
                            Image("google")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 19, height: 19)
                        }
                        .frame(width: 70, height: 22)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.orange.opacity(0.3))
                        .font(.headline)
                        .cornerRadius(15)
                        .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)
                        
                        Button(action: {
                            // Apple sign-in action
                        }) {
                            Image("appleicon")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 19, height: 19)
                        }
                        .frame(width: 70, height: 22)
                        .padding()
                        .foregroundColor(.orange)
                        .background(Color.orange.opacity(0.3))
                        .font(.headline)
                        .cornerRadius(15)
                        .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)
                    }
                }
                .padding(.top, 50)
            }
    
    }
}

#Preview {
    SIgnInScreen()
}
