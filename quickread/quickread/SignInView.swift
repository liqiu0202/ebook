//
//  SigninView.swift
//  quickread
//
//  Created by Li Qiu on 5/20/23.
//
import SwiftUI
import AuthenticationServices

struct SignInView: View {
    
    @StateObject private var signInWithAppleManager = SignInWithAppleManager()
    @State private var showErrorAlert = false
    
    var body: some View {
//        VStack {
            if signInWithAppleManager.isAuthorized {
                // Display ForYouView for logged-in user
                ForYouView()
            } else {
                VStack {
                    VStack {
                        Image("AppLogo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 150, height: 150)
                            .padding(.top, 80) // Add space above image
                        Text("Welcome to QuickRead")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.bottom, 50)
                    }
                    VStack {
                        SignInWithAppleButton(.signIn,
                                              onRequest: signInWithAppleManager.onRequest,
                                              onCompletion: signInWithAppleManager.onCompletion)
                        .frame(width: 300, height: 60)
                        Spacer()
                    }

                }
                .preferredColorScheme(.light) // Enforces the light theme
            }
//        }
    }
}

struct SigninView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
