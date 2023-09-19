//
//  HomeView.swift
//  MeetAndEat
//
//  Created by Jasmine Micallef on 19/07/2023.
//

import SwiftUI

struct HomeView: View {
        
    @Binding var showSignInView: Bool
    @StateObject private var viewModel = GridViewModel()
    
    var body: some View {
        
        ZStack {
            content
        }
    }
    
    var content: some View{
        
        ZStack{
            VStack {
                Text("Home")
                    .padding()
                    .font(.system(size: 35, weight: .semibold))
                    .frame(width: 350, alignment: .leading)
                
                Posts
                    
            }
            .frame(height: 750)
            
            DashBoard
        }
        .onAppear {
            viewModel.getGridItemsFromFirestore()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack(){
            HomeView(showSignInView: .constant(false))
        }
    }
}

extension HomeView {
    
    private var Posts: some View {
        
        return ScrollView {
            GridView(gridItems: viewModel.gridItems, spacing: 20, horizontalPadding: 70)
        }
    }
}
         
extension HomeView {

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
                        
                        Image(systemName: "house")
                            .resizable()
                            .frame(width: 35, height: 30)
                            .foregroundStyle(.white)
                        
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


