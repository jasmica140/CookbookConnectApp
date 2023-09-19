//
//  CommentView.swift
//  MeetAndEat
//
//  Created by Jasmine Micallef on 03/08/2023.
//

import SwiftUI


struct CommentView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @EnvironmentObject private var viewModel: CommentViewModel
//    @ObservedObject var viewModel = CommentViewModel()
    @StateObject private var profileViewModel = ProfileViewModel()
    
    @Binding var showSignInView: Bool
    let recipeId: String
    
    @State private var newComment: String = ""
    @State private var rate: Int = 0
    @State private var photoUrl: String = ""
    
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        formatter.dateFormat = "d/M/yy H:m"
        return formatter
    }

    
    var body: some View {
            
        VStack{
            previousComments
                .padding(.top, 20)
            writeComment
        }
        .onAppear {
            if let user = profileViewModel.user {
                viewModel.getRecipeById(recipeId: recipeId, currentUserId: user.userId)
            }
        }
        .task {
            try? await profileViewModel.loadCurrentUser()
            if let user = profileViewModel.user {
                viewModel.getRecipeById(recipeId: recipeId, currentUserId: user.userId)
            }
        }
    }
    
    func toggleLike(comment: COMMENT) async throws {
                
        if let user = profileViewModel.user, let index = viewModel.isLiked.firstIndex(where: { $0.commentId == comment.commentId }) {
            
            if comment.usersLiked.contains(user.userId) {
                try await CommentManager.shared.removeUserIdFromCommentLikes(commentId: comment.commentId, userId: user.userId)
                viewModel.isLiked[index].isLiked = false
                
            } else {
                try await CommentManager.shared.addUserIdtoCommentLikes(commentId: comment.commentId, userId: user.userId)
                viewModel.isLiked[index].isLiked = true

            }
        }

    }
}


struct CommentView_Previews: PreviewProvider {
    static var previews: some View {
        CommentView(showSignInView: .constant(false), recipeId: "7DDD31A9-86F5-49D8-A6AB-81ED4B4F3A2B")
    }
}

extension CommentView {
    
    private var previousComments: some View {
        
        return ScrollView {
            
            VStack{
                ForEach(viewModel.comments, id: \.commentId) { comment in
                    
                    VStack(spacing: 10) {
                        HStack(spacing: 20) {
                            ZStack {
                                Circle()
                                    .frame(width: 35, height: 35)
                                
                                AsyncImage(url: URL(string: viewModel.user?.photoUrl ?? "")){ phase in
                                    if let image = phase.image {
                                        image
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 35, height: 35, alignment: .center)
                                    }
                                }
                                .clipShape(Circle())
                            }
                            .frame(width: 35, alignment: .topLeading)
                            
                            
                            VStack(spacing: 10) {
                                Text("\(viewModel.user?.firstName?.capitalized ?? "Name") \(viewModel.user?.lastName?.capitalized ?? "Surname")")
                                    .font(.system(size: 15, weight: .semibold))
                                    .frame(width: 300, alignment: .leading)
                                
                                Text(comment.description)
                                    .font(.system(size: 15, weight: .light))
                                    .frame(width: 300, alignment: .leading)
                            }
                        }
                        .frame(width: 375, alignment: .leading)
                        
                        
                        
                        HStack{
                            
                            Text(dateFormatter.string(from: comment.datePublished))
                                .font(.system(size: 10, weight: .light))
                                .frame(width: 250, alignment: .leading)
                                .padding(.leading, 35)
                            
                            Text("\(comment.usersLiked.count)")
                                .font(.system(size: 10, weight: .light))
                                .frame(width: 30, alignment: .trailing)
                            
                            Button {
                                
                                Task {
                                    do {
                                        try await toggleLike(comment: comment)
                                    } catch {
                                        print(error)
                                    }
                                }
                                
                            } label : {
                                if let index = viewModel.isLiked.firstIndex(where: { $0.commentId == comment.commentId }) {
                                    Image(systemName: viewModel.isLiked[index].isLiked ? "hand.thumbsup.fill" : "hand.thumbsup")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 15)
                                }
                            }
                            .task {
                                try? await profileViewModel.loadCurrentUser()
                                if let user = profileViewModel.user, let index = viewModel.isLiked.firstIndex(where: { $0.commentId == comment.commentId }) {
                                    viewModel.isLiked[index].isLiked = comment.usersLiked.contains(user.userId)
                                }
                            }
                            .onAppear {
                                if let user = profileViewModel.user, let index = viewModel.isLiked.firstIndex(where: { $0.commentId == comment.commentId }) {
                                    viewModel.isLiked[index].isLiked = comment.usersLiked.contains(user.userId)
                                }
                            }
                        }
                        .frame(width: 335, alignment: .leading)

                        Rectangle()
                            .frame(width: 400, height: 1)
                            .padding(.bottom, 10)
                            .padding(.top, 10)
                    }
                    .onAppear {
                        viewModel.getUserById(userId: comment.userId)
                    }
                }
            }
        }
    }
}

extension CommentView {
    
    private var writeComment: some View {

        VStack {
            
            HStack(spacing: 13) {
                
                ZStack {
                    Circle()
                        .frame(width: 35, height: 35)
                    
                    if let user = profileViewModel.user {
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
                    }
                }
                .frame(width: 35, alignment: .topLeading)

                
                TextField("\(newComment)", text: $newComment, axis: .vertical)
                    .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                    .lineLimit(5)
                    .padding()
                    .font(.system(size: 15, weight: .light, design: .rounded))
                    .frame(width: 220)
                    .overlay(RoundedRectangle(cornerRadius: 20)
                        .stroke(.orange, lineWidth: 2))
                    .cornerRadius(20)

                HStack(spacing: 15) {
                    Button {
                        
                    } label: {
                        Image(systemName: "camera")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25)
                    }
                    
                    if let user = profileViewModel.user {
                        Button {
                            Task{
                                do {
                                    try await viewModel.registerComment(recipeId: recipeId, userId: user.userId , rate: rate, description: newComment, photoUrl: photoUrl)
                                    self.newComment = ""
                                    viewModel.getRecipeById(recipeId: recipeId, currentUserId: user.userId)
                                } catch{
                                    print(error)
                                }
                            }
                        } label: {
                            Image(systemName: "paperplane.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20)
                        }
                                                
                    } else {
                        Image(systemName: "paperplane.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20)
                            .foregroundColor(Color(#colorLiteral(red: 0.5906998515, green: 0.3929190338, blue: 0.285951823, alpha: 1)))
                    }
                }
            }
            .frame(width: 375, alignment: .center)
            .background(colorScheme == .dark ? Color.black : Color.white)
            .overlay(RoundedRectangle(cornerRadius: 20)
                .stroke(.orange, lineWidth: 2))
            .cornerRadius(20)
        }
    }
}
