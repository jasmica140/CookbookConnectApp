//
//  EmailSignUpView.swift
//  MeetAndEat
//
//  Created by Jasmine Micallef on 06/08/2023.
//

import SwiftUI

struct EmailSignUpView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @StateObject private var viewModel = EmailSignInViewModel()
    @StateObject private var imagePickerViewModel = ImagePickerModel()

    @Binding var showSignInView: Bool
    @State private var signUpOk = true

    @Binding var email: String
    @Binding var password: String

    @State private var selectedImage: UIImage?
    @State private var showingImagePicker = false
    @State private var photoUrl = ""

    var body: some View {
        
        VStack(spacing: 50) {
            
            Text("Sign Up With Email")
                .font(.system(size: 30, weight: .semibold))
                .frame(width: 310, alignment: .leading)
            
            content
        }
    }
}

extension EmailSignUpView {
    
    private var content: some View {
        
        VStack(spacing: 90){
            
            
            ZStack {
                Circle()
                    .fill(Color(#colorLiteral(red: 0.02800073847, green: 0.5427131057, blue: 0.5219461918, alpha: 1)))
                    .frame(height: 155)
                Circle()
                    .fill(Color(#colorLiteral(red: 0.02800073847, green: 0.5427131057, blue: 0.5219461918, alpha: 1)))
                    .frame(height: 40)
                    .padding(.leading, 100)
                    .padding(.top, 100)
                
                if let image = selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 150, height: 150, alignment: .center)
                        .clipShape(Circle())
                }
                
                Button {
                    showingImagePicker = true
                    
                } label : {
                    Image(systemName: "pencil.circle.fill")
                        .resizable()
                        .frame(width: 35, height: 35)
                        .padding(.leading, 100)
                        .padding(.top, 100)
                }
                .sheet(isPresented: $showingImagePicker, onDismiss: {
                }) {
                    ImagePicker(selectedImage: $selectedImage)
                }
            }
            
            VStack(spacing: 20) {
                TextField("Name", text: $viewModel.firstName)
                    .padding()
                    .background(colorScheme == .dark ? Color.white.opacity(0.2) : Color.black.opacity(0.1))
                    .font(.system(size: 20, weight: .light, design: .rounded))
                    .cornerRadius(20)
                    .shadow(color: Color.black.opacity(0.3), radius: 60, x: 0.0, y: 16)
                    .frame(width: 300)
                    .overlay(RoundedRectangle(cornerRadius: 20)
                        .stroke(Color(#colorLiteral(red: 0.02800073847, green: 0.5427131057, blue: 0.5219461918, alpha: 1))))
                
                TextField("Surname", text: $viewModel.lastName)
                    .padding()
                    .background(colorScheme == .dark ? Color.white.opacity(0.2) : Color.black.opacity(0.1))
                    .font(.system(size: 20, weight: .light, design: .rounded))
                    .cornerRadius(20)
                    .shadow(color: Color.black.opacity(0.3), radius: 60, x: 0.0, y: 16)
                    .frame(width: 300)
                    .overlay(RoundedRectangle(cornerRadius: 20)
                        .stroke(Color(#colorLiteral(red: 0.02800073847, green: 0.5427131057, blue: 0.5219461918, alpha: 1))))
                
                if !signUpOk {
                    Text("Account Already Exists!")
                        .font(.system(size: 15, weight: .light, design: .rounded))
                        .foregroundColor(.red)
                }else {
                    Text("")
                        .font(.system(size: 15, weight: .light, design: .rounded))
                }
            }
            
            if viewModel.firstName.isEmpty {
                Group { // Wrap in a Group for conditional rendering
                    Button {
                        signUpOk = false
                    } label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color(#colorLiteral(red: 0.02800073847, green: 0.5427131057, blue: 0.5219461918, alpha: 1)))
                                .frame(width: 300, height: 50)
                            
                            Text("Sign Up")
                                .font(.system(size: 20, weight: .light, design: .rounded))
                                .foregroundColor(.white)
                                .padding()
                        }
                    }
                }
            } else {
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
                                        try await viewModel.signUp(email: email, password: password, photoUrl: photoUrl)
                                        signUpOk = true
                                        showSignInView = false
                                        return
                                    } catch{
                                        signUpOk = false
                                        print(error)
                                    }
                                }
                            }
                        }
                    }

                } label: {
                    ZStack{
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color(#colorLiteral(red: 0.02800073847, green: 0.5427131057, blue: 0.5219461918, alpha: 1)))
                            .frame(width: 300, height: 50)
                        
                        Text("Sign Up")
                            .font(.system(size: 20, weight: .light, design: .rounded))
                            .foregroundColor(.white)
                            .padding()
                    }
                }
            }
        }
        .padding(30)
    }
}
    
struct EmailSignUpView_Previews: PreviewProvider {
    static var previews: some View {
        EmailSignUpView(showSignInView: .constant(false), email: .constant(""), password: .constant(""))
    }
}
