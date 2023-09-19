//
//  PostViewModel.swift
//  MeetAndEat
//
//  Created by Jasmine Micallef on 03/08/2023.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class PostViewModel: ObservableObject {
    
    @Published var recipe: RECIPE?
    @Published var user: USER?

    func getUserById(userId: String) {
        let db = Firestore.firestore()
        let usersCollection = db.collection("users")
        
        usersCollection.whereField("user_id", isEqualTo: userId)
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error)")
                    return
                }
                
                guard let documents = querySnapshot?.documents else {
                    print("No documents")
                    return
                }
                
                if let userDocument = documents.first {
                    do {
                        let user = try userDocument.data(as: USER.self)
                        self.user = user
                    } catch {
                        print("Error decoding user document: \(error)")
                    }
                } else {
                    print("User not found")
                }
            }
    }
    
    func getRecipeById(recipeId: String) {
        let db = Firestore.firestore()
        let recipesCollection = db.collection("recipes")
        
        recipesCollection.whereField("recipe_id", isEqualTo: recipeId)
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error)")
                    return
                }
                
                guard let documents = querySnapshot?.documents else {
                    print("No documents")
                    return
                }
                
                if let recipeDocument = documents.first {
                    do {
                        let recipe = try recipeDocument.data(as: RECIPE.self)
                        self.recipe = recipe
                        
                        self.getUserById(userId: recipe.userId)

                    } catch {
                        print("Error decoding recipe document: \(error)")
                    }
                } else {
                    print("Recipe not found")
                }
            }
    }
    
}
