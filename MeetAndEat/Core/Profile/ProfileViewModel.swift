//
//  ProfileViewModel.swift
//  MeetAndEat
//
//  Created by Jasmine Micallef on 08/08/2023.
//

import Foundation

import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

@MainActor
final class ProfileViewModel: ObservableObject {
    
    @Published public var userRecipes: [RECIPE] = []
    @Published public var user: USER? = nil
    
    func loadCurrentUser() async throws {
        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
        self.user = try await UserManager.shared.getUser(userId: authDataResult.uid)
    }
    
}
