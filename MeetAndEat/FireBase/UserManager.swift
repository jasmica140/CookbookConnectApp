//
//  UserManager.swift
//  MeetAndEat
//
//  Created by Jasmine Micallef on 24/07/2023.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift


struct USER: Codable{
    
    let userId: String
    let firstName: String?
    let lastName: String?
    let email: String?
    let role: ROLE
    let dateCreated: Date
    let photoUrl: String?
    let status: STATUS
    let userRecipes: [String]
    let likedRecipes: [String]
    
    init(auth: AuthDataResultModel) {
        self.userId = auth.uid
        self.firstName = auth.firstName
        self.lastName = ""
        self.email = auth.email
        self.role = ROLE.user
        self.dateCreated = Date()
        self.photoUrl = auth.photoUrl
        self.status = STATUS.active
        self.userRecipes = []
        self.likedRecipes = []
    }
    
    init(
    
    userId: String,
    firstName: String,
    lastName: String,
    email: String,
    role: ROLE,
    dateCreated: Date,
    photoUrl: String,
    status: STATUS,
    userRecipes: [String],
    likedRecipes: [String]
    
    ) {
        self.userId = userId
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.role = role
        self.dateCreated = dateCreated
        self.photoUrl = photoUrl
        self.status = status
        self.userRecipes = userRecipes
        self.likedRecipes = likedRecipes
    }
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case firstName = "first_name"
        case lastName = "last_name"
        case email = "email"
        case role = "role"
        case dateCreated = "date_created"
        case photoUrl = "photo_url"
        case status = "status"
        case userRecipes = "user_recipes"
        case likedRecipes = "liked_recipes"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userId = try container.decode(String.self, forKey: .userId)
        self.firstName = try container.decodeIfPresent(String.self, forKey: .firstName)
        self.lastName = try container.decodeIfPresent(String.self, forKey: .lastName)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
        self.role = try container.decode(ROLE.self, forKey: .role)
        self.dateCreated = try container.decode(Date.self, forKey: .dateCreated)
        self.photoUrl = try container.decodeIfPresent(String.self, forKey: .photoUrl)
        self.status = try container.decode(STATUS.self, forKey: .status)
        self.userRecipes = try container.decode([String].self, forKey: .userRecipes)
        self.likedRecipes = try container.decode([String].self, forKey: .likedRecipes)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.userId, forKey: .userId)
        try container.encodeIfPresent(self.firstName, forKey: .firstName)
        try container.encodeIfPresent(self.lastName, forKey: .lastName)
        try container.encodeIfPresent(self.email, forKey: .email)
        try container.encodeIfPresent(self.role, forKey: .role)
        try container.encodeIfPresent(self.photoUrl, forKey: .photoUrl)
        try container.encodeIfPresent(self.dateCreated, forKey: .dateCreated)
        try container.encodeIfPresent(self.status, forKey: .status)
        try container.encodeIfPresent(self.userRecipes, forKey: .userRecipes)
        try container.encodeIfPresent(self.likedRecipes, forKey: .likedRecipes)
    }
    
}

enum ROLE: Codable{
    case user
    case admin
    case anonymous
}

enum STATUS: Codable {
    case active
    case suspended
}

final class UserManager {
        
    static let shared = UserManager()
    
    private init() { }
    
    private let userCollection = Firestore.firestore().collection("users")
    
    private func userDocument(userId: String) -> DocumentReference {
        
        userCollection.document(userId)
    }
    
    func createNewUser(user: USER) async throws {
        
        try userDocument(userId: user.userId).setData(from: user, merge: false)
    }
    
    func getUser(userId: String) async throws -> USER {
        try await userDocument(userId: userId).getDocument(as: USER.self)
    }
    
    func addRecipeIdToUser(userId: String, recipeId: String) async throws {
        let data: [String:Any] = [
            USER.CodingKeys.userRecipes.rawValue: FieldValue.arrayUnion([recipeId])
        ]
        try await userDocument(userId: userId).updateData(data)
    }
    
    func removeRecipeIdFromUser(userId: String, recipeId: String) async throws {
        let data: [String:Any] = [
            USER.CodingKeys.userRecipes.rawValue: FieldValue.arrayRemove([recipeId])
        ]
        try await userDocument(userId: userId).updateData(data)
    }
    
    func addLikedRecipeIdToUser(userId: String, recipeId: String) async throws {
        let data: [String:Any] = [
            USER.CodingKeys.likedRecipes.rawValue: FieldValue.arrayUnion([recipeId])
        ]
        try await userDocument(userId: userId).updateData(data)
    }
    
    func removeLikedRecipeIdFromUser(userId: String, recipeId: String) async throws {
        let data: [String:Any] = [
            USER.CodingKeys.likedRecipes.rawValue: FieldValue.arrayRemove([recipeId])
        ]
        try await userDocument(userId: userId).updateData(data)
    }
}
