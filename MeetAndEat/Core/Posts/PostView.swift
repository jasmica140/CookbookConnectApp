//
//  PostView.swift
//  MeetAndEat
//
//  Created by Jasmine Micallef on 01/08/2023.
//

import SwiftUI

struct PostView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme

    @Binding var showSignInView: Bool
    @ObservedObject var viewModel = PostViewModel()
    @StateObject private var commentViewModel = CommentViewModel()
    @StateObject private var profileViewModel = ProfileViewModel()

    
    @State private var isLiked = false
    @State private var isCommentPresented = false

    @State private var selectedIngredients: Set<UUID> = []
    @State private var showDetails = false
    @State private var showIngredients = false
    @State private var showSteps = false
    
    @State private var asyncImageHeight: CGFloat = 0

    @State private var serves: Int =  1
    @State private var updatedIngredients: [INGREDIENT] = []

    
    let recipeId: String
    
    var body: some View {
        
        VStack {
            ZStack {

                RecipeDetails
                DashBoard
            }
            .onAppear {
                viewModel.getRecipeById(recipeId: recipeId)
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading:
                                Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "chevron.left")
                .foregroundColor(Color(#colorLiteral(red: 0.9923003316, green: 0.5927134156, blue: 0.3024604321, alpha: 1)))
                .imageScale(.large)
        })
        .padding(.bottom, 45)
    }
    
    private func toggleIngredient(_ ingredient: INGREDIENT) {
        if selectedIngredients.contains(ingredient.id) {
            selectedIngredients.remove(ingredient.id)
        } else {
            selectedIngredients.insert(ingredient.id)
        }
    }
    
    func toggleLike() async throws {
        if let user = profileViewModel.user {
            
            if user.likedRecipes.contains(recipeId) {
                try await UserManager.shared.removeLikedRecipeIdFromUser(userId: user.userId, recipeId: recipeId)
                try await RecipeManager.shared.removeUserIdFromRecipeLikes(recipeId: recipeId, userId: user.userId)
            } else {
                try await UserManager.shared.addLikedRecipeIdToUser(userId: user.userId, recipeId: recipeId)
                try await RecipeManager.shared.addUserIdToRecipeLikes(recipeId: recipeId, userId: user.userId)
            }
            isLiked.toggle()
        }
     }
}

struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        PostView(showSignInView: .constant(false), recipeId: "7DDD31A9-86F5-49D8-A6AB-81ED4B4F3A2B")
    }
}

struct ImageHeightKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

extension PostView {
    
    private var RecipeDetails: some View {
        
        return ScrollView {
            
            if let recipe = viewModel.recipe {
                
                VStack {
                    
                    GeometryReader{ reader in

                        AsyncImage(url : URL(string: recipe.photoUrl )){ phase in
                            if let image = phase.image {
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .background(
                                        GeometryReader { imageGeometry in
                                            Color.clear // Capture the height of the AsyncImage
                                                .preference(key: ImageHeightKey.self, value: imageGeometry.size.height)
                                        }
                                    )
                                    .onPreferenceChange(ImageHeightKey.self) { imageHeight in
                                        self.asyncImageHeight = imageHeight
                                    }
                                    .frame(width: reader.size.width, height: reader.size.height, alignment: .center)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 250)
                    .padding(.leading, 50)
                    .padding(.trailing, 50)
                    .padding(.bottom, asyncImageHeight/2)

                    VStack(spacing: 10) {

                        HStack(spacing: 0){
                            Text(recipe.title)
                                .font(.system(size: 20, weight: .light))
                                .frame(width: 300, alignment: .leading)
                            
                            
                            Button {
                                
                                Task {
                                    do {
                                        try await toggleLike()
                                    } catch {
                                        print(error)
                                    }
                                }
                                
                            } label : {
                                Image(systemName: isLiked ? "heart.fill" : "heart")
                                    .frame(width: 20, alignment: .trailing)
                                    .padding(.trailing)
                            }
                            .task {
                                try? await profileViewModel.loadCurrentUser()
                                if let user = profileViewModel.user {
                                    isLiked = user.likedRecipes.contains(recipeId)
                                }
                            }
                            .onAppear {
                                if let user = profileViewModel.user {
                                    isLiked = user.likedRecipes.contains(recipeId)
                                }
                            }
                            

                            Button {
                                isCommentPresented = true
                            } label: {
                               Image(systemName: "ellipsis.bubble")
                            }
                            .sheet(isPresented: $isCommentPresented) {
                                CommentView(showSignInView: $showSignInView, recipeId: recipe.recipeId)
                                    .presentationDetents([.height(600)])
                                    .environmentObject(commentViewModel)
                            }
                            .frame(width: 20, alignment: .trailing)

                        }
                        .frame(width: 355, alignment: .center)
                        .padding(.bottom, 5)
                        

                        Text(recipe.description ?? "description")
                            .font(.system(size: 15, weight: .light))
                            .frame(width: 355, alignment: .leading)
                            .padding(.bottom, 20)

                        VStack(spacing: 0) {
                            recipeDetails
                            Ingredients
                            Steps
                        }
                    }
                }
            } else {
                Text("Loading...")
                    .foregroundColor(.white)
                    .frame(alignment: .center)
                    .padding(500)
            }
        }
    }
}

extension PostView {
    
    private var recipeDetails: some View {
        
        VStack {
            
            if let recipe = viewModel.recipe {
                
                Button(action : {
                    showDetails.toggle()
                }) {
                    VStack(spacing: 12.5) {
                        Rectangle()
                            .fill(colorScheme == .dark ? Color.white : Color.black)
                            .frame(width: 500, height: 1)
                        HStack {
                            Text("Recipe Details")
                                .font(.system(size: 20, weight: .light))
                            if showDetails {
                                Image(systemName: "minus")
                            } else {
                                Image(systemName: "chevron.down")
                            }
                        }
                        .frame(width: 355, alignment: .leading)
                        
                        if showDetails {
                            Rectangle()
                                .fill(colorScheme == .dark ? Color.white : Color.black)
                                .frame(width: 500, height: 1)
                        } else {
                            Text("")
                                .padding(-5)
                        }
                    }
                }
                
                if showDetails {
                    
                    if let cuisine = recipe.country{
                        
                        VStack(spacing: 20) {
                            HStack(spacing: 40) {
                                VStack(spacing: 10) {
                                    Text("Prep Time")
                                        .font(.system(size: 15, weight: .light))
                                    Text("\(recipe.prepTime/60) hrs \(recipe.prepTime % 60) mins")
                                        .font(.system(size: 20, weight: .light))
                                }
                                Rectangle()
                                    .fill(colorScheme == .dark ? Color.white : Color.black)
                                    .frame(width: 1, height: 50)
                                
                                VStack(spacing: 10) {
                                    Text("Cook Time")
                                        .font(.system(size: 15, weight: .light))
                                    Text("\(recipe.cookTime/60) hrs \(recipe.cookTime % 60) mins")
                                        .font(.system(size: 20, weight: .light))
                                }
                                
                            }
                            .frame(width: 355, alignment: .center)
                            
                            VStack(spacing: 10) {
                                Rectangle()
                                    .fill(colorScheme == .dark ? Color.white : Color.black)
                                    .frame(width: 335, height: 1)
                                    .padding(.bottom, 5)
                                Text("Total Time")
                                    .font(.system(size: 15, weight: .light))
                                Text("\((recipe.prepTime + recipe.cookTime)/60) hrs \((recipe.prepTime + recipe.cookTime) % 60) mins")
                                    .font(.system(size: 20, weight: .light))
                                    .padding(.bottom, 5)
                                Rectangle()
                                    .fill(colorScheme == .dark ? Color.white : Color.black)
                                    .frame(width: 335, height: 1)
                            }
                            .frame(width: 355, alignment: .center)
                            
                            VStack (spacing: 10){
                                Text("Cuisine : \(cuisine.capitalized)")
                                    .font(.system(size: 15, weight: .light))
                                    .frame(width: 335, alignment: .leading)
                                
                                Text("Catagory : \(String(describing: recipe.recipeType).capitalized)")
                                    .font(.system(size: 15, weight: .light))
                                    .frame(width: 335, alignment: .leading)
                            }
                            .padding(.bottom, 20)
                        }
                        .padding(.top, 10)
                    }

                }
                
            } else {
                Text("Loading...")
            }
        }
    }
}
    
extension PostView {
    
    private var Ingredients: some View {
        
        VStack {
            
            if let recipe = viewModel.recipe {
                
                Button(action : {
                    showIngredients.toggle()
                }) {
                    VStack(spacing: 12.5) {
                        Rectangle()
                            .fill(colorScheme == .dark ? Color.white : Color.black)
                            .frame(width: 500, height: 1)
                        HStack {
                            Text("Ingredients")
                                .font(.system(size: 20, weight: .light))
                            if showIngredients {
                                Image(systemName: "minus")
                            } else {
                                Image(systemName: "chevron.down")
                            }
                        }
                        .frame(width: 355, alignment: .leading)
                        
                        if showIngredients {
                            Rectangle()
                                .fill(colorScheme == .dark ? Color.white : Color.black)
                                .frame(width: 500, height: 1)
                        }
                    }
                }
                
                if showIngredients {
                    
                    VStack {
                        
                        HStack(spacing: 5) {
                            Text("Serves: ")
                                .font(.system(size: 15, weight: .light))
                            
                            ZStack{
                                Rectangle()
                                    .fill(colorScheme == .dark ? Color.white.opacity(0.3) : Color.gray.opacity(0.2))
                                    .cornerRadius(7)
                                
                                TextField("", value: $serves, format: .number)
                                    .keyboardType(.numberPad)
                                    .onChange(of: serves) { newValue in
                                        let sanitizedValue = min(newValue, Int(pow(10, Double(3))) - 1)
                                        if sanitizedValue != newValue {
                                            serves = sanitizedValue
                                        }
                                    }
                                    .font(.system(size: 15, weight: .light))
                                    .cornerRadius(20)
                                    .padding(.leading, 15)
                            }
                            .frame(width: 55, height: 25)
                            .padding(.trailing, 10)
                            
                            Button(action: {
                                updatedIngredients = recipe.ingredients.map { ingredient in
                                    let newAmount = (ingredient.amount * serves) / recipe.serves
                                    return INGREDIENT(amount: newAmount, metric: ingredient.metric, ingredient: ingredient.ingredient)
                                }
                            }) {
                                Image(systemName: "arrow.clockwise")
                            }
                        }
                        .frame(width: 355, alignment: .leading)
                        .padding(.bottom, 15)
                        
                        
                        if !updatedIngredients.isEmpty {
                            ForEach(updatedIngredients) { ingredient in
                                Button(action: {
                                    toggleIngredient(ingredient)
                                }) {
                                    HStack {
                                        Image(systemName: selectedIngredients.contains(ingredient.id) ? "checkmark.square.fill" : "square")
                                            .resizable()
                                            .frame(width: 15, height: 15)
                                        Text("\(ingredient.amount) \(String(describing: ingredient.metric)) \(ingredient.ingredient)")
                                            .font(.system(size: 15, weight: .light))
                                            .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                                    }
                                }
                                .frame(width: 355, alignment: .leading)
                                .padding(.bottom, 10)
                            }
                        } else {
                            ForEach(recipe.ingredients , id: \.ingredient) { ingredient in
                                Button(action: {
                                    toggleIngredient(ingredient)
                                }) {
                                    HStack {
                                        Image(systemName: selectedIngredients.contains(ingredient.id) ? "checkmark.square.fill" : "square")
                                            .resizable()
                                            .frame(width: 15, height: 15)
                                        Text("\(ingredient.amount ) \(String(describing: ingredient.metric)) of \(ingredient.ingredient )")
                                            .font(.system(size: 15, weight: .light))
                                            .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                                    }
                                    .frame(width: 355, alignment: .leading)
                                    .padding(.bottom, 10)
                                }
                            }
                        }
                    }
                    .padding(.top, 10)
                }
                
            } else {
                Text("Loading...")
                    .foregroundColor(.white)
            }
        }
    }
}



extension PostView {
    
    private var Steps: some View {
        
        VStack {
            
            if let recipe = viewModel.recipe {
                
                Button(action : {
                    showSteps.toggle()
                }) {
                    VStack(spacing: 12.5) {
                        Rectangle()
                            .fill(colorScheme == .dark ? Color.white : Color.black)
                            .frame(width: 500, height: 1)
                            .padding(.top, 15)
                        
                        HStack {
                            Text("Steps")
                                .font(.system(size: 20, weight: .light))
                            if showSteps {
                                Image(systemName: "minus")
                            } else {
                                Image(systemName: "chevron.down")
                            }
                        }
                        .frame(width: 350, alignment: .leading)
                        
                        Rectangle()
                            .fill(colorScheme == .dark ? Color.white : Color.black)
                            .frame(width: 500, height: 1)
                    }
                }
                
                if showSteps {
                    VStack{
                        ForEach(Array(recipe.steps.enumerated()), id: \.1) { index, Step in
                            Text("\(index + 1). \(Step)")
                                .font(.system(size: 17, weight: .light))
                                .frame(width: 350, alignment: .leading)
                                .padding(.bottom, 10)
                        }
                    }
                    .padding(.top, 15)
                    .padding(.bottom, 15)
                }
            }
        }
        .padding(.bottom, 120)

    }
}

extension PostView {
    
    private var creatorDetails: some View {
        
        ZStack {
            Rectangle()
                .fill(colorScheme == .dark ? Color.black : Color.white)
                .frame(width: 500, height: 50)
            
            if let user = viewModel.user {
                HStack(spacing: 7) {
                    if let photoUrl = user.photoUrl{
                        AsyncImage(url: URL(string: photoUrl)){ phase in
                            if let image = phase.image {
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 35, height: 35, alignment: .center)
                            }
                        }
                        .clipShape(Circle())
                    }
                    
                    VStack{
                        Text("Created by:")
                            .font(.system(size: 10, weight: .light))
                            .frame(width: 350, alignment: .leading)
                        
                        if let firstName = user.firstName{
                            Text("\(firstName.capitalized)")
                                .font(.system(size: 15, weight: .light))
                                .frame(width: 350, alignment: .leading)
                                .padding(.leading,10)
                        }
                    }
                }
                .frame(width: 150)
                .padding(.leading, 120)
            }else {
                Text("")
            }
        }
    }
}

extension PostView {
    
    private var DashBoard: some View {
        
        VStack(spacing: 670){
            VStack(spacing: 0){
                Rectangle()
                    .fill(Color(#colorLiteral(red: 0.02800073847, green: 0.5427131057, blue: 0.5219461918, alpha: 1)))
                    .frame(width: 500, height: 70)
                creatorDetails
            }

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
                            Text("Hello")
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
