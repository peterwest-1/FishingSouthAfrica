//
//  SignUpView.swift
//  Fishing South Africa
//
//  Created by PV West on 2021/01/18.
//

import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var authentication: Authentication
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .trailing, vertical: .top), content: {
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
                        Text("Create")
                            .font(.system(size: 35, weight: .heavy))
                        
                        Text("Profile")
                            .font(.system(size: 35, weight: .medium))
                    }
                    
                    Text("Fishing Regulations")
                        .fontWeight(.heavy)
                }
                .padding(.top)
                
                VStack {
                    CustomTextField(placeholder: "Email", text: $authentication.emailRegister).keyboardType(.emailAddress)
                    CustomTextField(placeholder: "Password", text: $authentication.passwordRegister, isSecure: true)
                    CustomTextField(placeholder: "Confirm", text: $authentication.confirmPasswordRegister, isSecure: true)
                }
                .padding(.top)
                
                Button(action: authentication.signUp) {
                    Text("Sign Up")
                        .fontWeight(.bold)
                        .padding(.vertical)
                        .frame(width: UIScreen.main.bounds.width - 30)
                        .clipShape(Capsule())
                }
                .padding(.vertical, 22)
                
                Spacer(minLength: 0)
            }
            
            Button(action: { authentication.isRegister.toggle() }) {
                Image(systemName: "xmark")
                    .padding()
                    .clipShape(Circle())
            }
            .padding(.trailing)
            .padding(.top, 10)
            
            if authentication.isLoading {
                ProgressView()
            }
        })
        .background(LinearGradient(gradient: .init(colors: [Color("top"), Color("bottom")]), startPoint: .top, endPoint: .bottom).ignoresSafeArea(.all, edges: .all))
        // Alerts...
        .alert(isPresented: $authentication.alert, content: {
            Alert(title: Text("Message"), message: Text(authentication.alertMessage), dismissButton: .destructive(Text("Ok"), action: {
                // if email link sent means closing the signupView....
                
                if authentication.alertMessage == "Email Verification Has Been Sent" {
                    authentication.isRegister.toggle()
                    authentication.emailRegister = ""
                    authentication.passwordRegister = ""
                    authentication.confirmPasswordRegister = ""
                }
                
            }))
        })
    }
}
