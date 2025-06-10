

//
//  ProfileScreen.swift
//  NewsArticle
//
//  Created by Paranjothi iOS MacBook Pro on 10/06/25.
//  Profile page added on 10/06/25

//

import SwiftUI

struct ProfileScreen: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    @Binding var isSignedIn: Bool // Binding to control sign-in state

    @State private var username: String
    @State private var email: String
    @State private var showSignOutAlert = false

    // Initialize with user data and sign-in state binding
    init(username: String, email: String, isSignedIn: Binding<Bool>) {
        self._username = State(initialValue: username)
        self._email = State(initialValue: email)
        self._isSignedIn = isSignedIn
    }

    var body: some View {
        ZStack {
            // Gradient Background
            LinearGradient(
                gradient: Gradient(colors: [.orange.opacity(0.1), .white]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    HStack {
                        Button(action: {
                            withAnimation(.easeInOut) {
                                dismiss()
                            }
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.title2)
                                .foregroundColor(.black)
                                .padding(12)
                                .background(Color.white.opacity(0.9))
                                .clipShape(Circle())
                                .shadow(radius: 3)
                        }
                        .padding(.leading, 16)

                        Text("Profile")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundColor(.black)

                        Spacer()
                    }
                    .padding(.vertical, 16)

                    // User Avatar
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                        .foregroundColor(.orange.opacity(0.7))
                        .background(Color.white.opacity(0.9))
                        .clipShape(Circle())
                        .shadow(radius: 5)
                        .padding(.top, 20)

                    // User Information
                    VStack(spacing: 12) {
                        Text(username.isEmpty ? "User" : username)
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .foregroundColor(.black)

                        Text(email.isEmpty ? "No email provided" : email)
                            .font(.system(size: 16, design: .rounded))
                            .foregroundColor(.black.opacity(0.7))
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 16)
                    .background(Color.white.opacity(0.9))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(radius: 3)
                    .padding(.horizontal)

                    // Sign Out Button
                    Button(action: {
                        showSignOutAlert = true
                    }) {
                        Text("Sign Out")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .bold()
                            .background(Color.orange.opacity(0.4))
                            .foregroundColor(.black.opacity(0.7))
                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)
                    }
                    .padding(.horizontal)
                    .padding(.top, 20)
                    .alert(isPresented: $showSignOutAlert) {
                        Alert(
                            title: Text("Sign Out"),
                            message: Text("Are you sure you want to sign out?"),
                            primaryButton: .destructive(Text("Sign Out")) {
                                // Clear user data and navigate to sign-in screen
                                username = ""
                                email = ""
                                isSignedIn = false // Reset to show SIgnInScreen
                            },
                            secondaryButton: .cancel()
                        )
                    }

                    Spacer()
                }
                .padding(.bottom, 50)
            }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden()
    }
}

struct ProfileScreen_Previews: PreviewProvider {
    static var previews: some View {
        ProfileScreen(username: "JohnDoe", email: "john.doe@example.com", isSignedIn: .constant(true))
    }
}
