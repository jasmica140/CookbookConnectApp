//
//  AddRecipeView5.swift
//  MeetAndEat
//
//  Created by Jasmine Micallef on 26/07/2023.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseStorage

struct AddRecipeView5: View {
    
    @StateObject private var viewModel = AddRecipeModel()
    @StateObject private var profileViewModel = ProfileViewModel()
    @StateObject private var imagePickerViewModel = ImagePickerModel()

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
    
    @State private var selectedImage: UIImage?
    @State private var showingImagePicker = false
    
    var body: some View {
        
        VStack {
            ZStack{
                Rectangle()
                    .fill(Color(#colorLiteral(red: 0.02285940014, green: 0.541613996, blue: 0.5201182961, alpha: 1)))
                VStack(){
                    VStack(spacing: 5) {
                        Text("Add A Photo Of")
                            .font(.system(size: 30, weight: .bold))
                            .frame(width: 350, alignment: .center)
                            .foregroundColor(Color(#colorLiteral(red: 1, green: 0.6315597892, blue: 0.3300533295, alpha: 1)))
                        Text("Your Recipe")
                            .font(.system(size: 30, weight: .bold))
                            .frame(width: 350, alignment: .center)
                            .foregroundColor(Color(#colorLiteral(red: 1, green: 0.6315597892, blue: 0.3300533295, alpha: 1)))
                            .padding(3)
                    }
                    .frame(height: 100)

                    uploadImage
                        .frame(height: 400)
                        

                    postButton
                        .frame(height: 50)
                }
                .frame(height: 800)


                
                DashBoard
            }
        }
        .padding(.bottom, 50)
    }
}

struct AddRecipeView5_Previews: PreviewProvider {
    static var previews: some View {
        AddRecipeView5(showSignInView: .constant(false), title: .constant(""), description: .constant(""), ingredients: .constant([INGREDIENT(amount: 0, metric: METRIC.kg, ingredient: "")]), steps: .constant([""]), prepTime: .constant([0,0]), cookTime: .constant([0,0]), serves: .constant(0), country: .constant(""), recipeType: .constant(RECIPE_TYPE.starter), photoUrl: .constant(""))
    }
}

extension AddRecipeView5 {
    
    private var uploadImage: some View {
        
        VStack(spacing: 20) {
            if let image = selectedImage {
                VStack(spacing: 0) {
                    Rectangle()
                        .fill(.orange)
                        .frame(width: 500, height: 5)
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 400)
                        .frame(maxHeight: 300)
                    Rectangle()
                        .fill(.orange)
                        .frame(width: 500, height: 5)
                }
            }
            
            
            Button("Select Image") {
                showingImagePicker = true
            }
            .sheet(isPresented: $showingImagePicker, onDismiss: {
            }) {
                ImagePicker(selectedImage: $selectedImage)
            }
        }
    }
}

extension AddRecipeView5 {
    
    private var postButton: some View {
                
        VStack{
            
            ZStack{
                RoundedRectangle(cornerRadius: 20)
                    .frame(height: 57)
                
                if let user = profileViewModel.user {
                    Button {
                        
                        if let image = selectedImage {
                            imagePickerViewModel.convertImageToURL(image) { imageURL, error in
                                if let error = error {
                                    print("Error converting image to URL: \(error)")
                                } else if let imageURL = imageURL {
                                    self.photoUrl = imageURL
                                    print("Image URL: \(imageURL)")
                                    
                                    Task{
                                        do {
                                            try await viewModel.registerRecipe(userId: user.userId, title: title, description: description, ingredients: ingredients, steps: steps, prepTime: prepTime, cookTime: cookTime, serves: serves, country: country, recipeType: recipeType, photoUrl: photoUrl)
                                        } catch{
                                            print(error)
                                        }
                                    }
                                }
                            }
                        }
                        
                    } label: {
                        Text("Post")
                            .font(.system(size: 23, weight: .light, design: .rounded))
                            .padding()
                    }
                }
            }
            .task {
                try? await profileViewModel.loadCurrentUser()
            }
        }
        .frame(width: 300)

    }
}




extension AddRecipeView5 {
    
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
