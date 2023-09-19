//
//  SearchView.swift
//  MeetAndEat
//
//  Created by Jasmine Micallef on 08/08/2023.
//

import SwiftUI

struct SearchView: View {
    
    @Environment(\.colorScheme) var colorScheme

    @StateObject private var gridViewModel = GridViewModel()
    @StateObject private var profileViewModel = ProfileViewModel()

    @Binding var showSignInView: Bool
    
    @State private var searchText: String = ""
    @State private var isShowFilteredView: Bool = false

    var body: some View {

        ZStack {
            ScrollView {
                LazyVStack(spacing: 50) {
                    SearchBar
                    if isShowFilteredView {
                        filteredView
                    } else {
                        Carousels
                    }
                }
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
            .padding(.top, 100)
            .onAppear {
                gridViewModel.getTopGridItems()
                gridViewModel.getRandomGridItems()
            }

            DashBoard
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack(){
            SearchView(showSignInView: .constant(false))
        }
    }
}


extension SearchView {
    
    private var SearchBar: some View {
        
        VStack {
            
            HStack(spacing: 15) {
                
                TextField("\(searchText)", text: $searchText, axis: .vertical)
                    .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                    .lineLimit(5)
                    .padding()
                    .font(.system(size: 15, weight: .light, design: .rounded))
                    .frame(width: 295)
                    .overlay(RoundedRectangle(cornerRadius: 20)
                        .stroke(.orange, lineWidth: 2))
                    .cornerRadius(20)
                
                Button {
                    self.searchText = ""
                    self.isShowFilteredView = true
                } label: {
                    Image(systemName: "magnifyingglass")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25)
                }
                .padding(.trailing, 15)
            }
            .frame(width: 350, height: 40, alignment: .center)
            .background(colorScheme == .dark ? Color.black : Color.white)
            .overlay(RoundedRectangle(cornerRadius: 20)
                .stroke(.orange, lineWidth: 2))
            .cornerRadius(20)
        }
    }
}

extension SearchView {
    
    private var filteredView: some View {
        GridView(gridItems: gridViewModel.filteredGridItems, spacing: 20, horizontalPadding: 70)
            .onAppear {
                gridViewModel.getGridItemsFromFirestore()
            }
    }
}

extension SearchView {
    
    private var Carousels: some View {
        
        VStack(spacing: -75) {
            
            VStack(spacing: -100) {

                Text("Top Posts this Week")
                    .font(.system(size: 25, weight: .semibold, design: .default))
                    .frame(width: 350, alignment: .leading)
                
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        LazyHStack {
                            ForEach (gridViewModel.topGridItems) { gridItem in
                                getItemView(gridItem: gridItem)
                            }
                        }
                    }
                }
                .padding(.leading, 75)
            }

            
            VStack(spacing: -100) {
                Text("Recommended for You ")
                    .font(.system(size: 25, weight: .semibold, design: .default))
                    .frame(width: 350, alignment: .leading)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        LazyHStack {
                            ForEach (gridViewModel.randomGridItems) { gridItem in
                                getItemView(gridItem: gridItem)
                            }
                        }
                    }
                }
                .padding(.leading, 75)
            }


        }
        .frame(height: 650)
    }
    
    func getItemView(gridItem: GridItem) -> some View{
        ZStack{
            NavigationLink {
                PostView(showSignInView: .constant(false), recipeId: gridItem.recipeId)
            } label: {
                
                AsyncImage(url : URL(string: gridItem.imgString)){ phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width:150, height: 200, alignment: .center)
                    } else {
                        Color.gray.opacity(0.4)
                            .frame(width: 150, height: 200)
                    }
                }
            }
            
            ZStack(){
                Rectangle()
                    .fill(.black.opacity(0.3))
                VStack{
                    Text("\(gridItem.title.capitalized)")
                        .font(.system(size: 15, weight: .light, design: .rounded))
                }
                .foregroundColor(.white)
                .frame(width: 135, alignment: .leading)
            }
            .frame(height: 50)
            .padding(.top, 150)
        }
        .frame(width: 150, height: 200)
        .clipShape (RoundedRectangle(cornerRadius: 13))
    }
}


extension SearchView {

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


