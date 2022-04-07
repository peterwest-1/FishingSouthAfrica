//
//  LoginView.swift
//  Fishing South Africa
//
//  Created by PV West on 2021/01/18.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authentication: Authentication
    
    var body: some View {
        ZStack {
            VStack {
                Spacer(minLength: 0)
                
                ZStack {
                    if UIScreen.main.bounds.height < 750 {
                        Image("logo")
                            .resizable()
                            .frame(width: 130, height: 130)
                    }
                    else {
                        Image("logo")
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 20)
                .cornerRadius(30)
                .padding(.top)
                
                VStack(spacing: 4) {
                    HStack(spacing: 0) {
                        Text("Fishing")
                            .font(.system(size: 35, weight: .heavy))
                        Text("SouthAfrica")
                            .font(.system(size: 35, weight: .medium))
                    }
                    
                    Text("Fishing Regulations")
                        
                        .fontWeight(.heavy)
                }
                .padding(.top)
                
                VStack {
                    CustomTextField(placeholder: "Email", text: $authentication.email).keyboardType(.emailAddress).autocapitalization(.none)
                    CustomTextField(placeholder: "Password", text: $authentication.password, isSecure: true)
                }
                
                Button(action: authentication.login) {
                    Text("Login")
                        .fontWeight(.bold)
                        .padding(.vertical)
                        .frame(width: UIScreen.main.bounds.width - 30)
                        .clipShape(Capsule())
                }
                .padding(.top, 22)
                
                HStack(spacing: 12) {
                    Text("Don't have an account?")
                    
                    Button(action: { authentication.isRegister.toggle() }) {
                        Text("Sign Up Now")
                            .fontWeight(.bold)
                    }
                }
                .padding(.top, 25)
                
                Spacer(minLength: 0)
                
                Button(action: authentication.resetPassword) {
                    Text("Forgot Password?")
                        .fontWeight(.bold)
                }
                .padding(.vertical, 22)
            }
            
            if authentication.isLoading {
                ProgressView()
            }
        }
        .fullScreenCover(isPresented: $authentication.isRegister) {
            SignUpView(authentication: _authentication)
        }
        .alert(isPresented: $authentication.alert, content: {
            Alert(title: Text("Message"), message: Text(authentication.alertMessage), dismissButton: .destructive(Text("Confirm")))
        })
    }
}
