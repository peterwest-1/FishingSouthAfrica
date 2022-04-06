//
//  AuthenticationState.swift
//  FishingSouthAfrica
//
//  Created by Pete West on 2022/03/30.
//

import AuthenticationServices
import Firebase
import FirebaseFirestore
import Foundation
import SwiftUI

class Authentication: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var isRegister = false
    @Published var emailRegister = ""
    @Published var passwordRegister = ""
    @Published var confirmPasswordRegister = ""
    @Published var isLinkSend = false
    @Published var alert = false
    @Published var alertMessage = ""
    
    @AppStorage("authentication") var status = false
    
    @Published var isLoading = false
    
    func resetPassword() {
        let alert = UIAlertController(title: "Reset Password", message: "Enter Your Email To Reset Your Password", preferredStyle: .alert)
        
        alert.addTextField { password in
            password.placeholder = "Email"
        }
        
        let proceed = UIAlertAction(title: "Reset", style: .default) { _ in
            
            if alert.textFields![0].text! != "" {
                withAnimation {
                    self.isLoading.toggle()
                }
                
                Auth.auth().sendPasswordReset(withEmail: alert.textFields![0].text!) { err in
                    
                    withAnimation {
                        self.isLoading.toggle()
                    }
                    
                    if err != nil {
                        self.alertMessage = err!.localizedDescription
                        self.alert.toggle()
                        return
                    }
                    
                    self.alertMessage = "Password Reset Link Has Been Sent"
                    self.alert.toggle()
                }
            }
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        
        alert.addAction(cancel)
        alert.addAction(proceed)
        
//        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true)
    }
    
    func login() {
        if email == "" || password == "" {
            alertMessage = "Fill the contents properly"
            alert.toggle()
            return
        }
        
        withAnimation {
            self.isLoading.toggle()
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { _, err in
            
            withAnimation {
                self.isLoading.toggle()
            }
            
            if err != nil {
                self.alertMessage = err!.localizedDescription
                self.alert.toggle()
                return
            }
            
//            let user = Auth.auth().currentUser
            
//            if !user!.isEmailVerified {
//                self.alertMsg = "Please Verify Email Address"
//                self.alert.toggle()
//                try! Auth.auth().signOut()
//
//                return
//            }
            
            withAnimation {
                self.status = true
            }
        }
    }
    
    func signUp() {
        if emailRegister == "" || passwordRegister == "" || confirmPasswordRegister == "" {
            alertMessage = "Fill contents properly"
            alert.toggle()
            return
        }
        
        if passwordRegister != confirmPasswordRegister {
            alertMessage = "Password Mismatch"
            alert.toggle()
            return
        }
        
        withAnimation {
            self.isLoading.toggle()
        }
        
        Auth.auth().createUser(withEmail: emailRegister, password: passwordRegister) { result, err in
            
            withAnimation {
                self.isLoading.toggle()
            }
            
            if err != nil {
                self.alertMessage = err!.localizedDescription
                self.alert.toggle()
                return
            }
            if let userId = result?.user.uid {
                UserService.shared.addUser(uid: userId)
            }
            
//            result?.user.sendEmailVerification(completion: { err in
//
//                if err != nil {
//                    self.alertMsg = err!.localizedDescription
//                    self.alert.toggle()
//                    return
//                }
//
//                self.alertMsg = "Email Verification Has Been Sent"
//                self.alert.toggle()
//            })
        }
    }
    
    func logout() {
        try! Auth.auth().signOut()
        
        withAnimation {
            self.status = false
        }
        
        email = ""
        password = ""
        emailRegister = ""
        passwordRegister = ""
        confirmPasswordRegister = ""
    }
}
