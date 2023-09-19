//
//  EmailSignInViewModel.swift
//  MeetAndEat
//
//  Created by Jasmine Micallef on 24/07/2023.
//

import Foundation
import UIKit

@MainActor
final class EmailSignInViewModel: ObservableObject{
    
    @Published var email = ""
    @Published var password = ""
    @Published var firstName = ""
    @Published var lastName = ""

    func signUp(email: String, password: String, photoUrl: String) async throws{
        guard !email.isEmpty, !password.isEmpty, !firstName.isEmpty else{
            print("No Email or Password Found!")
            return
        }
        
        let authDataResult = try await AuthenticationManager.shared.createUser(email: email, password: password)
        let user = USER(auth:authDataResult)
        let newUser = USER(userId: user.userId, firstName: firstName, lastName: lastName, email: email, role: ROLE.user, dateCreated: Date(), photoUrl: photoUrl, status: STATUS.active, userRecipes: [], likedRecipes: [])
        try await UserManager.shared.createNewUser(user: newUser)
    }
    
    func signIn() async throws{
        guard !email.isEmpty, !password.isEmpty else{
            print("No Email or Password Found!")
            return
        }
        
        try await AuthenticationManager.shared.signInUser(email: email, password: password)
    }
}
