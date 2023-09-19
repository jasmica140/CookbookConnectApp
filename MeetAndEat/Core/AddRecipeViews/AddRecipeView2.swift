//
//  AddRecipeView2.swift
//  MeetAndEat
//
//  Created by Jasmine Micallef on 25/07/2023.
//

import SwiftUI
import Combine

struct AddRecipeView2: View {
    
    @Binding var showSignInView: Bool

    @Binding var title: String
    @Binding var description: String
    @Binding var ingredients: [INGREDIENT]
    @Binding var steps: [String]
    @Binding var prepTime: [Int]
    @Binding var cookTime: [Int]
    @Binding var serves: Int
    @Binding var country: String
    @Binding var recipeType: RECIPE_TYPE
    @Binding var photoUrl: String
    
    var body: some View {
        
        VStack {
            ZStack{
                Rectangle()
                    .fill(Color(#colorLiteral(red: 0.02285940014, green: 0.541613996, blue: 0.5201182961, alpha: 1)))
                VStack{
                    
                    Text("Add Your Ingredients")
                        .font(.system(size: 30, weight: .bold))
                        .frame(width: 350, alignment: .topLeading)
                        .foregroundColor(Color(#colorLiteral(red: 1, green: 0.6315597892, blue: 0.3300533295, alpha: 1)))
                        .padding(.leading, 30)
                        .padding(3)

                    Text("Dont forget to include the measurements :)")
                        .font(.system(size: 15, weight: .regular, design: .rounded))
                        .frame(width: 350, alignment: .leading)
                        .foregroundColor(.white)
                        .padding(.leading, 30)
                        .padding(.bottom, 40)

                    VStack{
                        
                        textFields

                        ZStack{
                            Rectangle()
                                .fill(.white)
                                .cornerRadius(20)
                                .frame(height: 50)
                                .padding(30)
                            
                            if !ingredients.isEmpty {
                                
                                NavigationLink {
                                    AddRecipeView3(showSignInView: $showSignInView, title: $title, description: $description, ingredients: $ingredients, steps: $steps, prepTime: $prepTime, cookTime: $cookTime, serves: $serves, country: $country, recipeType: $recipeType, photoUrl: $photoUrl)
                                } label: {
                                    Text("Continue")
                                        .font(.system(size: 23, weight: .light, design: .rounded))
                                }
                            }
                        }
                    }
                    .frame(width: 325, height: 500)
                }
                DashBoard
            }
        }
        .padding(.bottom, 50)
    }
}

struct AddRecipeView2_Previews: PreviewProvider {
    static var previews: some View {
        AddRecipeView2(showSignInView: .constant(false), title: .constant(""), description: .constant(""), ingredients: .constant([INGREDIENT(amount: 0, metric: METRIC.kg, ingredient: "")]), steps: .constant([""]), prepTime: .constant([0,0]), cookTime: .constant([0,0]), serves: .constant(0), country: .constant(""), recipeType: .constant(RECIPE_TYPE.starter), photoUrl: .constant(""))
    }
}

extension AddRecipeView2 {
    
    private var textFields: some View {
                    
        VStack {
            
            ForEach($ingredients) { $Ingredient in
                
                ZStack {

                        HStack(spacing: 0) {
                            
                            TextField("", value: $Ingredient.amount, format: .number)
                                .keyboardType(.numberPad)
                                .padding(10)
                                .font(.system(size: 15, weight: .light, design: .rounded))
                                .cornerRadius(20)
                                .frame(width: 65, height: 40)

                            
                            Picker( String(describing: Ingredient.metric), selection: $Ingredient.metric) {
                                ForEach(METRIC.allCases) { option in
                                    Text(String(describing: option))
                                }
                            }
                            .pickerStyle(.menu)
                            .cornerRadius(20)
                            .frame(width: 70, height: 40)
                            .border(.white, width: 1)
                            
                            Text("of")
                                .padding()
                                .font(.system(size: 20, weight: .light, design: .rounded))
                                .frame(width: 50, height: 40)
                                .border(.white, width: 1)
                            
                            TextField("", text: $Ingredient.ingredient)
                                .padding(10)
                                .font(.system(size: 15, weight: .light, design: .rounded))
                                .cornerRadius(20)
                                .frame(width: 135, height: 40)
                        }
                        .foregroundColor(.white)
                        .frame(width: 300)
                        .padding(.bottom, 10)
                }
                .frame(width: 325, height: 40, alignment: .top)
                .overlay(RoundedRectangle(cornerRadius: 20)
                    .stroke(.white)
                )
            }
            Button("Add Item") {
                ingredients.append(INGREDIENT(amount: 0, metric: METRIC.kg, ingredient: "Item \(ingredients.count + 1)"))
            }
        }
    }
}






extension AddRecipeView2 {
    
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
                            Text("Hello")
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
