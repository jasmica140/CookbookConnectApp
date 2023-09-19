//
//  GridView.swift
//  MeetAndEat
//
//  Created by Jasmine Micallef on 31/07/2023.
//

import SwiftUI
import FirebaseFirestoreSwift
import Firebase
import FirebaseFirestore

class GridViewModel: ObservableObject {
    
    @ObservedObject var postViewModel = PostViewModel()

    @Published var gridItems: [GridItem] = []
    @Published var filteredGridItems: [GridItem] = []
    @Published var topGridItems: [GridItem] = []
    @Published var randomGridItems: [GridItem] = []
    @Published var recipe: RECIPE?

    func getGridItemsFromFirestore() {
        let db = Firestore.firestore()

        db.collection("recipes").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error fetching data: \(error)")
                return
            }

            guard let documents = querySnapshot?.documents else {
                print("No documents found.")
                return
            }

            for document in documents {
                let photoUrl = document.data()["photo_url"] as? String
                let recipeId = document.data()["recipe_id"] as? String
                let title = document.data()["title"] as? String
                let description = document.data()["description"] as? String
                if let photoUrl = photoUrl, let recipeId = recipeId, let title = title, let description = description {
                    self.gridItems.append(GridItem(imgString: photoUrl, recipeId: recipeId, title: title, description: description))
                }
            }
        }
    }
    
    func filterGridItems(using recipeIds: [String]) {
        self.filteredGridItems = gridItems.filter { recipeIds.contains($0.recipeId) }
    }
    
    func getTopGridItems() {
        
        getGridItemsFromFirestore()
        
        var topRecipes: [RECIPE] = []

        for gridItem in gridItems {
            getRecipeById(recipeId: gridItem.recipeId)
            if let recipe = recipe {
                if topRecipes.count < 10 {
                    topRecipes.append(recipe)
                    topRecipes.sort { $0.usersLiked.count > $1.usersLiked.count }
                } else if recipe.usersLiked.count > topRecipes.last?.usersLiked.count ?? 0 {
                    topRecipes.removeLast()
                    topRecipes.append(recipe)
                    topRecipes.sort { $0.usersLiked.count > $1.usersLiked.count }
                }
            } else {
                print("recipe not found!")
            }
        }
        for recipe in topRecipes {
            self.topGridItems.append(GridItem(imgString: recipe.photoUrl, recipeId: recipe.recipeId, title: recipe.title, description: recipe.description ?? ""))
        }
    }
    
    func getRandomGridItems() {
        
        getGridItemsFromFirestore()
        
        guard gridItems.count >= 10 else {
            print("not enough items")
            return
        }
        
        var pickedIndices: Set<Int> = []

        while pickedIndices.count < 10 {
            let randomIndex = Int.random(in: 0..<gridItems.count)
            let gridItem = gridItems[randomIndex]
            
            if !pickedIndices.contains(randomIndex) {
                pickedIndices.insert(randomIndex)
                self.randomGridItems.append(gridItem)
            }
        }
    }
    
    func getRecipeById(recipeId: String) {
        let db = Firestore.firestore()
        let recipesCollection = db.collection("recipes")
        
        recipesCollection.whereField("recipe_id", isEqualTo: recipeId)
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error)")
                    return
                }
                
                guard let documents = querySnapshot?.documents else {
                    print("No documents")
                    return
                }
                
                if let recipeDocument = documents.first {
                    do {
                        let recipe = try recipeDocument.data(as: RECIPE.self)
                        self.recipe = recipe
                        
                    } catch {
                        print("Error decoding recipe document: \(error)")
                    }
                } else {
                    print("Recipe not found")
                }
            }
    }
}

struct GridItem: Identifiable{
    let id = UUID()
    let height = CGFloat.random (in: 175 ... 350)
    let imgString: String
    let recipeId: String
    let title: String
    let description: String
}

struct GridView: View {
        
    struct Column: Identifiable{
        let id = UUID()
        var gridItems = [GridItem]()
    }
    
    let Columns: [Column]
    let spacing: CGFloat
    let horizontalPadding: CGFloat
    
    init(gridItems: [GridItem], numOfColumns: Int = 2, spacing: CGFloat = 20,
         horizontalPadding: CGFloat = 20) {
        self.spacing = spacing
        self.horizontalPadding = horizontalPadding
        var Columns = [Column]()
        for _ in 0 ..< numOfColumns {
            Columns.append (Column ())
        }
        
        var columnsHeight = Array<CGFloat> (repeating: 0, count: numOfColumns)
        for gridItem in gridItems {
            
            var smallestColumnIndex = 0
            var smallestHeight = columnsHeight.first!
            for i in 1 ..< columnsHeight.count {
                let curHeight = columnsHeight[i]
                if curHeight < smallestHeight {
                    smallestHeight = curHeight
                    smallestColumnIndex = i
                }
            }
            Columns[smallestColumnIndex].gridItems.append(gridItem)
            columnsHeight[smallestColumnIndex] += gridItem.height
        }
        self.Columns = Columns
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: spacing) {
            ForEach(Columns) { column in
                LazyVStack(spacing: spacing) {
                    ForEach (column.gridItems) { gridItem in
                        getItemView(gridItem: gridItem)
                    }
                }
            }
        }
        .padding(.horizontal, horizontalPadding)
    }
    
    func getItemView(gridItem: GridItem) -> some View{
        ZStack{
            GeometryReader{ reader in
                NavigationLink {
                    PostView(showSignInView: .constant(false), recipeId: gridItem.recipeId)
                } label: {
                    
                    AsyncImage(url : URL(string: gridItem.imgString)){ phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: reader.size.width, height: reader.size.height, alignment: .center)
                        } else {
                            // Placeholder view while the image is loading
                            Color.gray.opacity(0.4)
                                .frame(width: reader.size.width, height:  reader.size.height * 0.75) // You can change the placeholder size and aspect ratio here
                        }
                    }
                }

                ZStack(){
                    Rectangle()
                        .fill(.black.opacity(0.3))
                    VStack{
                        Text("\(gridItem.title.capitalized)")
                            .font(.system(size: 15, weight: .light, design: .rounded))
//                        Text("\(gridItem.description)")
//                            .font(.system(size: 10, weight: .light, design: .rounded))
                    }
                    .foregroundColor(.white)
                    .frame(width: 135, alignment: .leading)
                }
                .frame(height: 50)
                .padding(.top, gridItem.height-50)
                
            }
            .frame(height: gridItem.height)
            .frame(maxWidth: .infinity)
            .clipShape (RoundedRectangle(cornerRadius: 13))
        }
    }
}

struct GridView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            GridView(gridItems: [GridItem(imgString: "", recipeId: "", title: "", description: "")])
        }
    }
}
