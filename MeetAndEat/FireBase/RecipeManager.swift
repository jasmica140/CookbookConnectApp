//
//  RecipeManager.swift
//  MeetAndEat
//
//  Created by Jasmine Micallef on 25/07/2023.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift


struct RECIPE: Codable {
    
    let recipeId: String
    let userId: String
    let title: String
    let description: String?
    let ingredients: [INGREDIENT]
    let steps: [String]
    let prepTime: Int
    let cookTime: Int
    let serves: Int
    let country: String?
    let recipeType: RECIPE_TYPE
    let comments: [String]
    let usersLiked: [String]
    let photoUrl: String
    
    init(
        recipeId: String,
        userId: String,
        title: String,
        description: String?,
        ingredients: [INGREDIENT],
        steps: [String],
        prepTime: Int,
        cookTime: Int,
        serves: Int,
        country: String?,
        recipeType: RECIPE_TYPE,
        comments: [String],
        usersLiked: [String],
        photoUrl: String
    ){
        self.recipeId = recipeId
        self.userId = userId
        self.title = title
        self.description = description
        self.ingredients = ingredients
        self.steps = steps
        self.prepTime = prepTime
        self.cookTime = cookTime
        self.serves = serves
        self.country = country
        self.recipeType = recipeType
        self.comments = comments
        self.usersLiked = usersLiked
        self.photoUrl = photoUrl
    }
    
    enum CodingKeys: String, CodingKey {
        
        case recipeId = "recipe_id"
        case userId = "user_id"
        case title = "title"
        case description = "description"
        case ingredients = "ingredients"
        case steps = "steps"
        case prepTime = "prep_time"
        case cookTime = "cook_time"
        case serves = "serves"
        case country = "country"
        case recipeType = "recipe_type"
        case comments = "comments"
        case usersLiked = "users_liked"
        case photoUrl = "photo_url"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.recipeId = try container.decode(String.self, forKey: .recipeId)
        self.userId = try container.decode(String.self, forKey: .userId)
        self.title = try container.decode(String.self, forKey: .title)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.ingredients = try container.decode([INGREDIENT].self, forKey: .ingredients)
        self.steps = try container.decode([String].self, forKey: .steps)
        self.prepTime = try container.decode(Int.self, forKey: .prepTime)
        self.cookTime = try container.decode(Int.self, forKey: .cookTime)
        self.serves = try container.decode(Int.self, forKey: .serves)
        self.country = try container.decodeIfPresent(String.self, forKey: .country)
        self.recipeType = try container.decode(RECIPE_TYPE.self, forKey: .recipeType)
        self.comments = try container.decode([String].self, forKey: .comments)
        self.usersLiked = try container.decode([String].self, forKey: .usersLiked)
        self.photoUrl = try container.decode(String.self, forKey: .photoUrl)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.recipeId, forKey: .recipeId)
        try container.encodeIfPresent(self.userId, forKey: .userId)
        try container.encodeIfPresent(self.title, forKey: .title)
        try container.encodeIfPresent(self.description, forKey: .description)
        try container.encodeIfPresent(self.ingredients, forKey: .ingredients)
        try container.encodeIfPresent(self.steps, forKey: .steps)
        try container.encodeIfPresent(self.prepTime, forKey: .prepTime)
        try container.encodeIfPresent(self.cookTime, forKey: .cookTime)
        try container.encodeIfPresent(self.serves, forKey: .serves)
        try container.encodeIfPresent(self.country, forKey: .country)
        try container.encodeIfPresent(self.recipeType, forKey: .recipeType)
        try container.encodeIfPresent(self.comments, forKey: .comments)
        try container.encodeIfPresent(self.usersLiked, forKey: .usersLiked)
        try container.encodeIfPresent(self.photoUrl, forKey: .photoUrl)
    }
}

struct INGREDIENT: Codable, Identifiable {
        
    var id = UUID()
    var amount: Int
    var metric: METRIC
    var ingredient: String
    
    init(amount: Int, metric: METRIC, ingredient: String) {
        self.amount = amount
        self.metric = metric
        self.ingredient = ingredient
    }
}

enum METRIC: Codable, CaseIterable, Identifiable, CustomStringConvertible {
    case kg
    case ml
    case oz
    case g
    case spoons
    case teaspoons
    
    var id: Self { self }
    
    var description: String {

        switch self {
        case .kg:
            return "kg"
        case .ml:
            return "ml"
        case .oz:
            return "oz"
        case .g:
            return "g"
        case .spoons:
            return "spns"
        case .teaspoons:
            return "tsps"
            
        }
    }
}

enum RECIPE_TYPE: Codable, CaseIterable, Identifiable, CustomStringConvertible{
    case starter
    case meat
    case dessert
    case vegetarian
    case mainDish
    case nonAlcoholicDrink
    case alcoholicDrink
    
    var id: Self { self }

    var description: String {

        switch self {
        case .starter:
            return "starter"
        case .meat:
            return "meat"
        case .dessert:
            return "dessert"
        case .vegetarian:
            return "vegetarian"
        case .mainDish:
            return "mainDish"
        case .nonAlcoholicDrink:
            return "nonAlcoholicDrink"
        case .alcoholicDrink:
            return "alcoholicDrink"
        }
    }
}


final class RecipeManager {
    
    static let shared = RecipeManager()
    
    private init() { }
    
    private let recipeCollection = Firestore.firestore().collection("recipes")
    
    private func recipeDocument(recipeId: String) -> DocumentReference {
        
        recipeCollection.document(recipeId)
    }
    
    func createNewRecipe(recipe: RECIPE) async throws {
        try recipeDocument(recipeId: recipe.recipeId).setData(from: recipe, merge: false)
    }

    
    func getRecipe(recipeId: String) async throws -> RECIPE {
        try await recipeDocument(recipeId: recipeId).getDocument(as: RECIPE.self)
    }
    
    func addUserIdToRecipeLikes(recipeId: String, userId: String) async throws {
        let data: [String:Any] = [
            RECIPE.CodingKeys.usersLiked.rawValue: FieldValue.arrayUnion([userId])
        ]
        try await recipeDocument(recipeId: recipeId).updateData(data)
    }
    
    func removeUserIdFromRecipeLikes(recipeId: String, userId: String) async throws {
        let data: [String:Any] = [
            RECIPE.CodingKeys.usersLiked.rawValue: FieldValue.arrayRemove([userId])
        ]
        try await recipeDocument(recipeId: recipeId).updateData(data)
    }
    
    func addCommentIdToRecipe(recipeId: String, commentId: String) async throws {
        let data: [String:Any] = [
            RECIPE.CodingKeys.comments.rawValue: FieldValue.arrayUnion([commentId])
        ]
        try await recipeDocument(recipeId: recipeId).updateData(data)
    }
    
    func removeCommentIdFromRecipe(recipeId: String, commentId: String) async throws {
        let data: [String:Any] = [
            RECIPE.CodingKeys.comments.rawValue: FieldValue.arrayRemove([commentId])
        ]
        try await recipeDocument(recipeId: recipeId).updateData(data)
    }
}
