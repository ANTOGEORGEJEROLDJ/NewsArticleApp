//
//  NewsArticleApp.swift
//  NewsArticle
//
//  Created by Paranjothi iOS MacBook Pro on 09/06/25.
//

import SwiftUI
import FirebaseCore
import Firebase
import CoreData

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct NewsArticleApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    let persistenceController = PersistenceController.shared

    // ✅ Add State for isSignedIn
    @State private var isSignedIn: Bool = true

    var body: some Scene {
        WindowGroup {
            NavigationView {
//                HomeScreen(topic: "", isSignedIn: $isSignedIn) // ✅ Pass Binding
                SelectNewsScreen(username: "", email: "")
//                SIgnInScreen()
            }
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init() {
        container = NSPersistentContainer(name: "Model") // Replace with your actual model name
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Core Data load failed: \(error), \(error.userInfo)")
            }
        }
    }
}
