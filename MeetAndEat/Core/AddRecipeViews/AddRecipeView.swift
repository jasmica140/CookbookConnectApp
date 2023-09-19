//
//  AddRecipeView.swift
//  MeetAndEat
//
//  Created by Jasmine Micallef on 24/07/2023.
//

import SwiftUI


@MainActor
final class AddRecipeModel: ObservableObject {
            
    @Published var title = ""
    @Published var description = ""
    @Published var ingredients = [INGREDIENT(amount: 0, metric: METRIC.kg, ingredient: "")]
    @Published var steps = ["steps"]
    @Published var prepTime = [0,0]
    @Published var cookTime = [0,0]
    @Published var serves = 0
    @Published var country = "country"
    @Published var recipeType = RECIPE_TYPE.starter
    @Published var photoUrl = "photo_url"
        

    func registerRecipe(userId: String, title: String, description: String, ingredients: [INGREDIENT], steps: [String], prepTime: [Int], cookTime: [Int], serves: Int, country: String, recipeType: RECIPE_TYPE, photoUrl: String) async throws{
//
//        guard !title.isEmpty else {
//            print("No Title Found!")
//            return
//        }
        
        let prepTimeTotal = (prepTime[0]*60) + prepTime[1]
        let cookTimeTotal = (cookTime[0]*60) + cookTime[1]

        let recipe = RECIPE(recipeId: "\(UUID())", userId: userId, title: title, description: description, ingredients: ingredients, steps: steps, prepTime: prepTimeTotal, cookTime: cookTimeTotal, serves: serves, country: country, recipeType: recipeType, comments: [""], usersLiked: [], photoUrl: photoUrl)
        try await RecipeManager.shared.createNewRecipe(recipe: recipe)
        try await UserManager.shared.addRecipeIdToUser(userId: userId, recipeId: recipe.recipeId)
    }
}


struct AddRecipeView: View {
    
    @StateObject private var viewModel = AddRecipeModel()
    @Binding var showSignInView: Bool
        
    var body: some View {
        NavigationView {
            ZStack{
                
                Rectangle()
                    .fill(Color(#colorLiteral(red: 0.02285940014, green: 0.541613996, blue: 0.5201182961, alpha: 1)))
                
                VStack(spacing: 40){
                    
                    VStack{
                        Text("Create A New Recipe")
                            .font(.system(size: 30, weight: .bold))
                            .frame(width: 350, alignment: .topLeading)
                            .foregroundColor(Color(#colorLiteral(red: 1, green: 0.6315597892, blue: 0.3300533295, alpha: 1)))
                            .padding(.leading, 30)
                            .padding(3)

                        
                        Text("Start by adding a title and description.")
                            .font(.system(size: 15, weight: .regular, design: .rounded))
                            .frame(width: 350, alignment: .leading)
                            .foregroundColor(.white)
                            .padding(.leading, 30)
                    }

                    textFields
                }
                
                DashBoard
            }
        }
        .environmentObject(viewModel)
    }
}

struct AddRecipeView_Previews: PreviewProvider {
    static var previews: some View {
        AddRecipeView(showSignInView: .constant(false))
    }
}

extension AddRecipeView {
    
    private var textFields: some View {
        
        VStack(spacing: 40) {
            
            VStack {
                Text("Title")
                    .font(.system(size: 15, weight: .regular, design: .rounded))
                    .frame(width: 350, alignment: .topLeading)
                    .foregroundColor(.white)
                    .padding(.leading, 30)
                
                TextField("\(viewModel.title)", text: $viewModel.title)
                    .padding()
                    .background(Color.black.opacity(0.1))
                    .foregroundColor(.black)
                    .font(.system(size: 20, weight: .light, design: .rounded))
                    .cornerRadius(20)
            }

            VStack {
                Text("Description")
                    .font(.system(size: 15, weight: .regular, design: .rounded))
                    .frame(width: 350, alignment: .topLeading)
                    .foregroundColor(.white)
                    .padding(.leading, 30)
                
                TextField("\(viewModel.description)", text: $viewModel.description)
                    .frame(width: 300, height: 200, alignment: .topLeading)
                    .padding()
                    .background(Color.black.opacity(0.1))
                    .font(.system(size: 20, weight: .light, design: .rounded))
                    .foregroundColor(.black)
                    .cornerRadius(20)
            }
            
            ZStack{
                Rectangle()
                    .fill(.white)
                    .cornerRadius(20)
                    .frame(height: 50)
                    .padding(30)

                if !viewModel.title.isEmpty {
                    NavigationLink {
                        AddRecipeView2(showSignInView: $showSignInView, title: $viewModel.title, description: $viewModel.description, ingredients: $viewModel.ingredients, steps: $viewModel.steps, prepTime: $viewModel.prepTime, cookTime: $viewModel.cookTime, serves: $viewModel.serves, country: $viewModel.country, recipeType: $viewModel.recipeType, photoUrl: $viewModel.photoUrl)
                    } label: {
                        Text("Add Recipe")
                            .font(.system(size: 20, weight: .light, design: .rounded))
                    }
                }
            }
        }
        .frame(width: 325, height: 500)
        .padding(20)
        
    }
}

extension AddRecipeView {
    
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
                        
                        Image(systemName: "plus.app")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundStyle(.white)
                        
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
