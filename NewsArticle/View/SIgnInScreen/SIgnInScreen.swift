//
//  SIgnInScreen.swift
//  NewsArticle
//
//  Created by Paranjothi iOS MacBook Pro on 10/06/25.
//

import SwiftUI
import FirebaseAuth
import Firebase
import GoogleSignInSwift
import GoogleSignIn
import FirebaseCore

struct SIgnInScreen: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var UserName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var navigationToSelectNewsScreen = false
    
    @State private var isSignedIn = false
    @State private var errorMessage = ""
    
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
                    // NavigationLink to SelectNewsScreen
                    NavigationLink(
                        destination: SelectNewsScreen(username: UserName, email: email)
                            .environment(\.managedObjectContext, viewContext),
                        isActive: $navigationToSelectNewsScreen
                    ) {
                        EmptyView()
                    }
                    
                    // Login Button
                    Button(action: {
                        registerWithEmail()
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
                        // Google Sign-In Button
                        Button(action: {
                            handleGoogleSignIn()
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
                        
                        // Apple Sign-In Placeholder
                        Button(action: {
                            // TODO: Add Apple Sign-In
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
    
    // MARK: - Email Sign-In
    func signInWithEmail() {
        guard !email.isEmpty, !password.isEmpty else {
            print("Email or password cannot be empty.")
            return
        }

        guard email.contains("@"), email.contains(".") else {
            print("Invalid email format.")
            return
        }

        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("Login failed: \(error.localizedDescription)")
                return
            }

            print("Login successful!")
            self.UserName = authResult?.user.displayName ?? ""
            self.navigationToSelectNewsScreen = true
        }
    }

    func registerWithEmail() {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("Registration failed: \(error.localizedDescription)")
                return
            }

            print("User registered!")
            self.UserName = authResult?.user.displayName ?? ""
            self.navigationToSelectNewsScreen = true
        }
    }

    // MARK: - Google Sign-In
    func handleGoogleSignIn() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootVC = windowScene.windows.first?.rootViewController else {
            return
        }

        GIDSignIn.sharedInstance.signIn(withPresenting: rootVC) { result, error in
            if let error = error {
                print("❌ Google Sign-In failed: \(error.localizedDescription)")
                return
            }

            guard let result = result,
                  let idToken = result.user.idToken?.tokenString else { return }

            let credential = GoogleAuthProvider.credential(
                withIDToken: idToken,
                accessToken: result.user.accessToken.tokenString
            )

            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    print("❌ Firebase Sign-In failed: \(error.localizedDescription)")
                } else {
                    self.isSignedIn = true
                    self.UserName = authResult?.user.displayName ?? ""
                    self.email = authResult?.user.email ?? ""
                    self.navigationToSelectNewsScreen = true
                    print("✅ Google Sign-In Success: \(authResult?.user.email ?? "")")
                }
            }
        }
    }
}

#Preview {
    SIgnInScreen()
}
