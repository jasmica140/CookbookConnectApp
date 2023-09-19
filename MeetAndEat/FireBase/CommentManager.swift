//
//  CommentManager.swift
//  MeetAndEat
//
//  Created by Jasmine Micallef on 03/08/2023.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift


struct COMMENT: Codable {
    
    let commentId: String
    let recipeId: String
    let userId: String
    let datePublished: Date
    let rate: Int
    let description: String
    let usersLiked: [String]
    let photoUrl: String?
    
    init(
        commentId: String,
        recipeId: String,
        userId: String,
        datePublished: Date,
        rate: Int,
        description: String,
        usersLiked: [String],
        photoUrl: String?
    ){
        self.commentId = commentId
        self.recipeId = recipeId
        self.userId = userId
        self.datePublished = datePublished
        self.rate = rate
        self.description = description
        self.usersLiked = usersLiked
        self.photoUrl = photoUrl
    }
    
    enum CodingKeys: String, CodingKey {
        
        case commentId = "comment_id"
        case recipeId = "recipe_id"
        case userId = "user_id"
        case datePublished = "date_published"
        case rate = "rate"
        case description = "description"
        case usersLiked = "users_that_like"
        case photoUrl = "photo_url"
    }
    

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.commentId = try container.decode(String.self, forKey: .commentId)
        self.recipeId = try container.decode(String.self, forKey: .recipeId)
        self.userId = try container.decode(String.self, forKey: .userId)
        self.datePublished = try container.decode(Date.self, forKey: .datePublished)
        self.rate = try container.decode(Int.self, forKey: .rate)
        self.description = try container.decode(String.self, forKey: .description)
        self.usersLiked = try container.decode([String].self, forKey: .usersLiked)
        self.photoUrl = try container.decodeIfPresent(String.self, forKey: .photoUrl)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.commentId, forKey: .commentId)
        try container.encode(self.recipeId, forKey: .recipeId)
        try container.encodeIfPresent(self.userId, forKey: .userId)
        try container.encodeIfPresent(self.datePublished, forKey: .datePublished)
        try container.encodeIfPresent(self.rate, forKey: .rate)
        try container.encodeIfPresent(self.description, forKey: .description)
        try container.encodeIfPresent(self.usersLiked, forKey: .usersLiked)
        try container.encodeIfPresent(self.photoUrl, forKey: .photoUrl)
    }
}

final class CommentManager {
    
    static let shared = CommentManager()
    
    private init() { }
    
    private let commentCollection = Firestore.firestore().collection("comments")
    
    private func commentDocument(commentId: String) -> DocumentReference {
        
        commentCollection.document(commentId)
    }
    
    func createNewComment(comment: COMMENT) async throws {
        try commentDocument(commentId: comment.commentId).setData(from: comment, merge: false)
    }

    
    func getComment(commentId: String) async throws -> COMMENT {
        try await commentDocument(commentId: commentId).getDocument(as: COMMENT.self)
    }
    
    func addUserIdtoCommentLikes(commentId: String, userId: String) async throws {
        let data: [String:Any] = [
            COMMENT.CodingKeys.usersLiked.rawValue: FieldValue.arrayUnion([userId])
        ]
        try await commentDocument(commentId: commentId).updateData(data)
    }
    
    func removeUserIdFromCommentLikes(commentId: String, userId: String) async throws {
        let data: [String:Any] = [
            COMMENT.CodingKeys.usersLiked.rawValue: FieldValue.arrayRemove([userId])
        ]
        try await commentDocument(commentId: commentId).updateData(data)
    }
    
}
