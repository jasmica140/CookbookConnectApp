//
//  ProfileView.swift
//  MeetAndEat
//
//  Created by Jasmine Micallef on 24/07/2023.
//

import SwiftUI


struct ProfileView: View {
    
    @Binding var showSignInView: Bool
    @StateObject private var viewModel = ProfileViewModel()
    @StateObject private var gridViewModel = GridViewModel()
    

    var body: some View {
        
        ZStack {
            content
        }
    }
    
    var content: some View{
        
        ZStack{
            
                
            VStack(spacing: 20)  {
                ScrollView {
                    
                    PersonalDetail
                    
                    Buttons
                        .padding(.bottom, 20)
                    Posts
                }
                .padding(.top, 100)
            }
            
            
            DashBoard
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            ProfileView(showSignInView: .constant(false))
        }
    }
}

extension ProfileView {
    
    private var Posts: some View {
        
        GridView(gridItems: gridViewModel.filteredGridItems, spacing: 20, horizontalPadding: 70)
            .onAppear {
                gridViewModel.getGridItemsFromFirestore()
            }
    }
}


extension ProfileView {
    
    private var PersonalDetail: some View {
        
        VStack(spacing: 10){
            
            ZStack{
                
                Circle()
                    .fill(Color(#colorLiteral(red: 0.02800073847, green: 0.5427131057, blue: 0.5219461918, alpha: 1)))
                    .frame(width: 100)
                    .padding(20)
                
                if let user = viewModel.user {
                    if let photoUrl = user.photoUrl{
                        AsyncImage(url: URL(string: photoUrl))
                            .clipShape(Circle())
                    }
                }

            }
            
            if let user = viewModel.user {
                if let firstName = user.firstName, let lastName = user.lastName{
                    Text ("\(firstName) \(lastName)")
                        .font(.system(size: 25, weight: .light, design: .rounded))
                }
                if let email = user.email {
                    Text ("\(email)")
                        .font(.system(size: 15, weight: .light, design: .rounded))
                        .padding(.bottom, 10)
                }
            } else {
                Text ("Name Surname")
                    .font(.system(size: 25, weight: .light, design: .rounded))
                
                Text ("hello@test.com")
                    .font(.system(size: 15, weight: .light, design: .rounded))
                    .padding(.bottom, 20)
            }
            
        }
        .task {
            try? await viewModel.loadCurrentUser()
        }
    }
}


extension ProfileView {
    
    private var Buttons: some View {
        
        ZStack{
            
            HStack(spacing: 30){
                
                Button("My Recipes") {
                    if let user = viewModel.user {
                        gridViewModel.filterGridItems(using: user.userRecipes)
                    }
                }
                

                Button("Saved") {
                    if let user = viewModel.user {
                        gridViewModel.filterGridItems(using: user.likedRecipes)
                    }
                }
                
            }
            .padding(.trailing, 25)

        }
        
    }
}

extension ProfileView {
    
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
                        
                        Image(systemName: "person.fill")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundStyle(.white)
                        
                        NavigationLink {
                            SettingsView(showSignInView: $showSignInView)
                                .navigationBarBackButtonHidden(true)
                        } label: {
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
}
