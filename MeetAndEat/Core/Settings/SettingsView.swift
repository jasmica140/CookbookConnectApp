//
//  SettingsView.swift
//  MeetAndEat
//
//  Created by Jasmine Micallef on 19/07/2023.
//

import SwiftUI

    
struct SettingsView: View {
    
    @StateObject private var viewModel = SettingsViewModel()
    @Binding var showSignInView: Bool
    
    var body: some View {

        ZStack{
            
            VStack{
                
                Text("Settings")
                    .font(.system(size: 35, weight: .semibold))
                    .frame(width: 350, alignment: .leading)

                List {
                    
                    ProfileSection
                    
                    if viewModel.authProviders.contains(.email){
                        emailSection
                    }
                    
                    Button("Log Out") {
                        Task {
                            do {
                                try viewModel.signOut()
                                showSignInView = true
                            } catch {
                                print(error)
                            }
                        }
                    }
                }
                .onAppear {
                    viewModel.loadAuthProviders()
                }
                .frame(width: 400, height: 625)
            }
            
            DashBoard
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            SettingsView(showSignInView: .constant(false))
        }
    }
}

extension SettingsView {
    
    private var ProfileSection: some View {
        
        Section {
            
            Button("Update Profile Picture"){
                
            }
                        
        } header: {
            Text("Edit Profile")
        }
        
    }
}

extension SettingsView {
    
    private var emailSection: some View {
        
        Section {
            Button("Reset Password") {
                Task {
                    do {
                        try await viewModel.resetPassword()
                        print("Password Reset!")
                    } catch {
                        print(error)
                    }
                }
            }
            
            Button("Change Password") {
                Task {
                    do {
                        try await viewModel.updatePassword()
                        print("Password Updated!")
                    } catch {
                        print(error)
                    }
                }
            }
            
            Button("Change Email") {
                Task {
                    do {
                        try await viewModel.updateEmail()
                        print("Email Updated!")
                    } catch {
                        print(error)
                    }
                }
            }
        } header: {
            Text("Email Functions")
        }
    }
}

extension SettingsView {
    
    private var DashBoard: some View {
        
        VStack(spacing: 720){
            Rectangle()
                .fill(Color(#colorLiteral(red: 0.02800073847, green: 0.5427131057, blue: 0.5219461918, alpha: 1)))
                .frame(width: 500, height: 70)
            
            VStack(spacing: 0){
                Rectangle()
                    .fill(Color(#colorLiteral(red: 0.02800073847, green: 0.5427131057, blue: 0.5219461918, alpha: 1)))
                    .frame(width: 500, height: 20)
                
                ZStack(alignment: .top){
                    Rectangle()
                        .fill(Color(#colorLiteral(red: 0.02800073847, green: 0.5427131057, blue: 0.5219461918, alpha: 1)))
                        .frame(width: 500, height: 100)
                    
                    
                    HStack(spacing: 40){
                        
                        NavigationLink {
                            HomeView(showSignInView: $showSignInView)
                                .navigationBarBackButtonHidden(true)
                        } label: {
                            Image(systemName: "house")
                                .resizable()
                                .frame(width: 35, height: 30)
                                .foregroundStyle(.white)
                        }
                        
                        NavigationLink {
                            SearchView(showSignInView: $showSignInView)
                                .navigationBarBackButtonHidden(true)
                        } label: {
                            Image(systemName: "magnifyingglass")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundStyle(.white)
                        }
                        
                        NavigationLink {
                            AddRecipeView(showSignInView: $showSignInView)
                                .navigationBarBackButtonHidden(true)
                        } label: {
                            Image(systemName: "plus.app")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundStyle(.white)
                        }
                        
                        NavigationLink {
                            ProfileView(showSignInView: $showSignInView)
                                .navigationBarBackButtonHidden(true)
                        } label: {
                            Image(systemName: "person.fill")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .foregroundStyle(.white)
                        }
                        
                        Image(systemName: "list.dash")
                            .resizable()
                            .frame(width: 25, height: 22)
                            .foregroundStyle(.white)
                    }
                }
            }
        }
    }
}
