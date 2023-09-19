//
//  AddRecipeView4.swift
//  MeetAndEat
//
//  Created by Jasmine Micallef on 25/07/2023.
//

import SwiftUI

struct AddRecipeView4: View {
    
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
                    Text("Final Edits")
                        .font(.system(size: 30, weight: .bold))
                        .frame(width: 350, alignment: .topLeading)
                        .foregroundColor(Color(#colorLiteral(red: 1, green: 0.6315597892, blue: 0.3300533295, alpha: 1)))
                        .padding(.leading, 30)
                        .padding(3)
                    
                    textFields
                }
                DashBoard
            }
        }
        .padding(.bottom, 50)
    }
}

struct AddRecipeView4_Previews: PreviewProvider {
    static var previews: some View {
        AddRecipeView4(showSignInView: .constant(false), title: .constant(""), description: .constant(""), ingredients: .constant([INGREDIENT(amount: 0, metric: METRIC.kg, ingredient: "")]), steps: .constant([""]), prepTime: .constant([0,0]), cookTime: .constant([0,0]), serves: .constant(0), country: .constant(""), recipeType: .constant(RECIPE_TYPE.starter), photoUrl: .constant(""))
    }
}

extension AddRecipeView4 {
    
    private var textFields: some View {
                
        VStack{
            
            VStack{
                
                Rectangle()
                    .frame(width: 325, height: 1)
                HStack(spacing: 15) {
                    
                    Text("Preperation Time: ")
                        .font(.system(size: 20, weight: .regular, design: .rounded))
                        .frame(width: 100, alignment: .topLeading)
                        .foregroundColor(.white)
                    
                    Picker("\(prepTime[0])", selection: $prepTime[0]) {
                        ForEach(0...23, id: \.self) {
                            Text("\($0) hr")
                                .foregroundColor(.white)
                        }
                    }
                    Picker("\(prepTime[1])", selection: $prepTime[1]) {
                        ForEach(0...59, id: \.self) {
                            Text("\($0) min")
                                .foregroundColor(.white)
                        }
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .cornerRadius(20)
                .frame(width: 325, height: 100)
                
                HStack(spacing: 15) {
                    
                    Text("Cooking Time:")
                        .font(.system(size: 20, weight: .regular, design: .rounded))
                        .frame(width: 100, alignment: .topLeading)
                        .foregroundColor(.white)

                    Picker("\(cookTime[0])", selection: $cookTime[0]) {
                        ForEach(0...23, id: \.self) {
                            Text("\($0) hr")
                                .foregroundColor(.white)
                        }
                    }
                    Picker("\(cookTime[1])", selection: $cookTime[1]) {
                        ForEach(0...59, id: \.self) {
                            Text("\($0) min")
                                .foregroundColor(.white)
                        }
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .cornerRadius(20)
                
                

                HStack{
                    VStack {
                        Text("Cuisine: ")
                            .font(.system(size: 15, weight: .regular, design: .rounded))
                            .frame(alignment: .topLeading)
                            .foregroundColor(.white)
                        
                        TextField("", text: $country)
                            .padding()
                            .background(Color.black.opacity(0.1))
                            .font(.system(size: 20, weight: .light, design: .rounded))
                            .cornerRadius(20)
                    }
                    
                    VStack {
                        Text("Serves: ")
                            .font(.system(size: 15, weight: .regular, design: .rounded))
                            .frame(alignment: .topLeading)
                            .foregroundColor(.white)
                        
                        TextField("", value: $serves, format: .number)
                            .keyboardType(.numberPad)
                            .padding()
                            .background(Color.black.opacity(0.1))
                            .font(.system(size: 20, weight: .light, design: .rounded))
                            .cornerRadius(20)
                    }
                }
                
                
                VStack {
                    
                    Text("Meal Type: ")
                        .font(.system(size: 15, weight: .regular, design: .rounded))
                        .frame(width: 305, alignment: .topLeading)
                        .foregroundColor(.white)
                    
                    Picker( String(describing: recipeType), selection: $recipeType) {
                        ForEach(RECIPE_TYPE.allCases) { option in
                            Text(String(describing: option))
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .cornerRadius(20)
                }
                
                                        
            }
            
            ZStack{
                RoundedRectangle(cornerRadius: 20)
                    .frame(height: 57)
                
                NavigationLink {
                    if !prepTime.isEmpty, !cookTime.isEmpty, serves>0{
                        AddRecipeView5(showSignInView: $showSignInView, title: $title, description: $description, ingredients: $ingredients, steps: $steps, prepTime: $prepTime, cookTime: $cookTime, serves: $serves, country: $country, recipeType: $recipeType, photoUrl: $photoUrl)
                    }
                } label: {
                    Text("Continue")
                        .font(.system(size: 23, weight: .light, design: .rounded))
                }
            }
        }
        .frame(width: 325, height: 500)
    }
}




extension AddRecipeView4 {
    
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
