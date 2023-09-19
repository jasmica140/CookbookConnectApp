//
//  RootView.swift
//  MeetAndEat
//
//  Created by Jasmine Micallef on 19/07/2023.
//

import SwiftUI

struct RootView: View {
    
    @State private var showSignInView: Bool = false
     
    var body: some View {
        ZStack {
            if !showSignInView {
                NavigationStack {
                    HomeView(showSignInView: $showSignInView)
                }
            }
        }
        .onAppear{
            let authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
            self.showSignInView = authUser == nil
        }
        .fullScreenCover(isPresented: $showSignInView) {
            NavigationStack {
                AuthenticationView(showSignInView: $showSignInView)
            }
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
