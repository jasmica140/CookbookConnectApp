//
//  EmailSignInView.swift
//  MeetAndEat
//
//  Created by Jasmine Micallef on 17/07/2023.
//

import SwiftUI


struct EmailSignInView: View {
    
    @Environment(\.colorScheme) var colorScheme

    @StateObject private var viewModel = EmailSignInViewModel()
    @Binding var showSignInView: Bool
    
    @State private var signInOk = true

    var body: some View {
        
        VStack(spacing: 150) {
            
            Text("Sign In With Email")
                .font(.system(size: 30, weight: .semibold))
                .frame(width: 300, alignment: .leading)
            
            content
        }
    }
        
    var content: some View{
        
        VStack(spacing: 110){

            VStack(spacing: 40){
                
                
                TextField("Email*", text: $viewModel.email)
                    .padding()
                    .background(colorScheme == .dark ? Color.white.opacity(0.2) : Color.black.opacity(0.1))
                    .font(.system(size: 20, weight: .light, design: .rounded))
                    .cornerRadius(20)
                    .shadow(color: Color.black.opacity(0.3), radius: 60, x: 0.0, y: 16)
                    .frame(width: 300)
                    .overlay(RoundedRectangle(cornerRadius: 20)
                        .stroke(Color(#colorLiteral(red: 0.02800073847, green: 0.5427131057, blue: 0.5219461918, alpha: 1))))
                    
                
                SecureField("Password*", text: $viewModel.password)
                    .padding()
                    .background(colorScheme == .dark ? Color.white.opacity(0.2) : Color.black.opacity(0.1))
                    .font(.system(size: 20, weight: .light, design: .rounded))
                    .cornerRadius(20)
                    .shadow(color: Color.black.opacity(0.3), radius: 60, x: 0.0, y: 16)
                    .frame(width: 300)
                    .overlay(RoundedRectangle(cornerRadius: 20)
                        .stroke(Color(#colorLiteral(red: 0.02800073847, green: 0.5427131057, blue: 0.5219461918, alpha: 1))))
                
                if !signInOk {
                    Text("Incorrect Email or Password!")
                        .font(.system(size: 15, weight: .light, design: .rounded))
                        .foregroundColor(.red)
                }else {
                    Text("")
                        .font(.system(size: 15, weight: .light, design: .rounded))
                }
            }
            

            VStack(spacing: 25){
                
                if viewModel.email.isEmpty || viewModel.password.isEmpty {
                    Group { // Wrap in a Group for conditional rendering
                        Button {
                            signInOk = false
                        } label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color(#colorLiteral(red: 0.02800073847, green: 0.5427131057, blue: 0.5219461918, alpha: 1)))
                                    .frame(width: 300, height: 50)
                                
                                Text("Sign In")
                                    .font(.system(size: 20, weight: .light, design: .rounded))
                                    .foregroundColor(.white)
                                    .padding()
                            }
                        }
                    }
                } else {
                    Button {
                        Task{
                            do {
                                try await viewModel.signIn()
                                signInOk = true
                                showSignInView = false
                                return
                            } catch{
                                signInOk = false
                                print(error)
                            }
                        }
                        
                    } label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color(#colorLiteral(red: 0.02800073847, green: 0.5427131057, blue: 0.5219461918, alpha: 1)))
                                .frame(width: 300, height: 50)
                            
                            Text("Sign In")
                                .font(.system(size: 20, weight: .light, design: .rounded))
                                .foregroundColor(.white)
                                .padding()
                        }
                    }
                }
      
                if viewModel.email.isEmpty || viewModel.password.isEmpty {
                    Group { // Wrap in a Group for conditional rendering
                        Button {
                            signInOk = false
                        } label : {
                            Text("Don't have an account? Create one here.")
                                .font(.system(size: 15, weight: .light, design: .rounded))
                                .underline(true, color: Color(#colorLiteral(red: 0.02800073847, green: 0.5427131057, blue: 0.5219461918, alpha: 1)))
                                .foregroundColor(Color.primary) // Use primary color
                                .frame(width: 300, alignment: .leading)
                        }
                    }
                } else {
                    Group {
                        NavigationLink {
                            EmailSignUpView(showSignInView: $showSignInView, email: .constant(viewModel.email), password: .constant(viewModel.password))
                        } label : {
                            Text("Don't have an account? Create one here.")
                                .font(.system(size: 15, weight: .light, design: .rounded))
                                .underline(true, color: Color(#colorLiteral(red: 0.02800073847, green: 0.5427131057, blue: 0.5219461918, alpha: 1)))
                                .foregroundColor(Color.primary) // Use primary color
                                .frame(width: 300, alignment: .leading)
                        }
                    }
                }
            }
                
            
        }
        .padding(30)
    }
}


struct EmailSignInView_Previews: PreviewProvider {
    static var previews: some View {
        EmailSignInView(showSignInView: .constant(false))
    }
}
