//
//  AuthenticationView.swift
//  MeetAndEat
//
//  Created by Jasmine Micallef on 17/07/2023.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift




struct AuthenticationView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @StateObject private var viewModel = AuthenticationViewModel()
    @Binding var showSignInView: Bool
    
    @State private var autoGoogleButton = false

    var body: some View {
        
        ZStack {
//            Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
//                .ignoresSafeArea()
            content
        }
    }
    
    var content: some View{
        
        VStack(spacing: 60) {

            Image(colorScheme == .dark ? "AppLogoBlack" : "AppLogoWhite")
                .resizable()
                .frame(width: 300, height: 300)
                .scaledToFit()
                .padding(.top, -20)

            VStack(spacing:20) {

                NavigationLink {
                    EmailSignInView(showSignInView: $showSignInView)
                } label: {
                    
                    ZStack{
                        RoundedRectangle(cornerRadius: 20)
                            .fill(colorScheme == .dark ? .white : .black)
                            .frame(width: 253, height: 43)
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.blue)
                            .frame(width: 250, height: 40)
                        Text("Log in / Sign Up with Email")
                            .font(.system(size: 15, weight: .light, design: .rounded))
                            .foregroundColor(.white)
                            .padding()
                    }
                }
                
            
                
                HStack{
                    RoundedRectangle(cornerRadius: 20)
                        .fill(colorScheme == .dark ? .white : .black)
                        .frame(width: 120, height: 1)
                    
                    Text("or")
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                        .font(.system(size: 15, weight: .light, design: .rounded))
                    
                    RoundedRectangle(cornerRadius: 20)
                        .fill(colorScheme == .dark ? .white : .black)
                        .frame(width: 120, height: 1)
                }
                
                Button {
                    Task{
                        do{
                            try await viewModel.GoogleSignIn()
                            showSignInView = false
                        } catch{
                            print(error)
                        }
                    }
                } label : {
                    ZStack{
                        RoundedRectangle(cornerRadius: 20)
                            .fill(colorScheme == .dark ? .white : .black)
                            .frame(width: 253, height: 43)
                        
                        HStack{
                            Image("GoogleLogo")
                                .resizable()
                                .frame(width: 18, height: 18)
                                .padding(1)
                            
                            Text("Sign in with Google")
                                .font(.system(size: 15, weight: .light, design: .rounded))
                                .foregroundColor(.black)
                                .padding(10)
                        }
                    }
                }
                

                
                ZStack{

                    RoundedRectangle(cornerRadius: 20)
                        .fill(colorScheme == .dark ? .white : .black)
                        .frame(width: 253, height: 43)
                    
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(#colorLiteral(red: 0.2799669504, green: 0.3511140347, blue: 0.5895133615, alpha: 1)))
                        .frame(width: 250, height: 40)
                    
                    HStack{
                        
                        Image("FacebookLogo")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .padding(1)
                        
                        NavigationLink {
                            Text("Hello")
                        } label: {
                                Text("Sign in with Facebook")
                                    .font(.system(size: 15, weight: .light, design: .rounded))
                                    .foregroundColor(.white)
                                    .padding(10)
                            }
                        }
                    }
                
                ZStack{
                    RoundedRectangle(cornerRadius: 20)
                        .fill(colorScheme == .dark ? .white : .black)
                        .frame(width: 253, height: 43)
                    
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.black)
                        .frame(width: 250, height: 40)
                    
                    HStack{
                        
                        Image("AppleLogo")
                            .resizable()
                            .frame(width: 10, height: 15)
                            .padding(-1)
                    
                        NavigationLink {
                            Text("Hello")
                        } label: {
                                Text("Sign in with Apple")
                                    .font(.system(size: 15, weight: .light, design: .rounded))
                                    .foregroundColor(.white)
                                    .padding()
                        }
                    }
                }
            }
        }
        .foregroundColor(.black)
    }
}



struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            AuthenticationView(showSignInView: .constant(false))
        }
    }
}
