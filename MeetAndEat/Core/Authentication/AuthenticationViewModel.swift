//
//  AuthenticationViewModel.swift
//  MeetAndEat
//
//  Created by Jasmine Micallef on 24/07/2023.
//

import Foundation

@MainActor
final class AuthenticationViewModel: ObservableObject{
    
    func GoogleSignIn() async throws{
        let helper = GoogleSignInHelper()
        let tokens = try await helper.signIn()
        let authDataResult = try await AuthenticationManager.shared.signInWithGoogle(tokens: tokens)
        let user = USER(auth:authDataResult)
        try await UserManager.shared.createNewUser(user: user)
    }
}
