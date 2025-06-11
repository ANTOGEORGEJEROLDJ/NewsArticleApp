//
//  CommentScreen.swift
//  NewsArticle
//
//  Created by Paranjothi iOS MacBook Pro on 11/06/25.
//

import SwiftUI
import CoreData

struct CommentScreen: View {
    let article: Article
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest var comments: FetchedResults<Comment>
    
    @State private var newComment = ""
    @FocusState private var isInputActive: Bool

    init(article: Article) {
        self.article = article
        _comments = FetchRequest<Comment>(
            sortDescriptors: [NSSortDescriptor(keyPath: \Comment.timestamp, ascending: true)],
            predicate: NSPredicate(format: "articleURL == %@", article.urlToImage ?? "")
        )
    }

    var body: some View {
        VStack(spacing: 0) {
            Capsule()
                .frame(width: 40, height: 5)
                .foregroundColor(.gray.opacity(0.3))
                .padding(.top, 8)

            Text("Comments")
                .font(.headline)
                .padding(.top, 4)

            Divider()

            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 15) {
                        ForEach(comments) { comment in
                            HStack(alignment: .top, spacing: 10) {
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .frame(width: 32, height: 32)
                                    .foregroundColor(.gray)

                                VStack(alignment: .leading, spacing: 4) {
                                    Text(comment.text ?? "")
                                        .font(.body)
                                        .foregroundColor(.primary)

                                    Text(comment.timestamp ?? Date(), style: .time)
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }

                                Spacer()
                            }
                            .padding(.horizontal)
                        }

                        // Anchor for scroll
                        Color.clear.frame(height: 1).id("Bottom")
                    }
                    .padding(.top)
                }
                .onChange(of: comments.count) { _ in
                    withAnimation {
                        proxy.scrollTo("Bottom", anchor: .bottom)
                    }
                }
            }

            Divider()

            // Input Bar
            HStack(spacing: 10) {
                TextField("Add a comment...", text: $newComment)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .focused($isInputActive)

                Button {
                    saveComment()
                } label: {
                    Image(systemName: "paperplane.fill")
                        .font(.title2)
                        .foregroundColor(.blue)
                }
                .disabled(newComment.trimmingCharacters(in: .whitespaces).isEmpty)
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
            .background(Color(UIColor.systemBackground))
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
        .onTapGesture {
            isInputActive = false
        }
    }

    private func saveComment() {
        let trimmed = newComment.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        let comment = Comment(context: viewContext)
        comment.id = UUID()
        comment.text = trimmed
        comment.timestamp = Date()
        comment.articleURL = article.urlToImage ?? "unknown"

        do {
            try viewContext.save()
            newComment = ""
        } catch {
            print("❌ Failed to save comment: \(error.localizedDescription)")
        }
    }
}
