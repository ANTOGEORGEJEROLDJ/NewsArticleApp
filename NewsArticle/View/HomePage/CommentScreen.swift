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

    init(article: Article) {
        self.article = article
        _comments = FetchRequest<Comment>(
            sortDescriptors: [NSSortDescriptor(keyPath: \Comment.timestamp, ascending: false)],
            predicate: NSPredicate(format: "articleURL == %@", article.urlToImage ?? "")
        )
    }

    var body: some View {
        VStack(spacing: 0) {
            Capsule()
                .frame(width: 40, height: 6)
                .foregroundColor(.gray.opacity(0.4))
                .padding(.top, 8)

            Text("Comments")
                .font(.headline)
                .padding(.top, 4)

            Divider()

            ScrollView {
                VStack(spacing: 12) {
                    ForEach(comments) { comment in
                        HStack(alignment: .top) {
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.gray)

                            VStack(alignment: .leading, spacing: 4) {
                                Text(comment.text ?? "")
                                    .font(.body)

                                Text(comment.timestamp ?? Date(), style: .time)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.top)
            }

            Divider()

            HStack {
                TextField("Add a comment...", text: $newComment)
                    .textFieldStyle(.roundedBorder)

                Button(action: saveComment) {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(.blue)
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 10)
        }
        .padding(.top)
    }

    private func saveComment() {
        guard !newComment.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        
        let comment = Comment(context: viewContext)
        comment.id = UUID()
        comment.text = newComment
        comment.timestamp = Date()
        comment.articleURL = article.urlToImage ?? ""
        
        do {
            try viewContext.save()
            newComment = ""
        } catch {
            print("Failed to save comment: \(error.localizedDescription)")
        }
    }
}
