//
//  CustomTextField.swift
//  FishingSouthAfrica
//
//  Created by Pete West on 2022/04/05.
//

import SwiftUI

struct CustomTextField: View {
    var placeholder: String
    @Binding var text: String
    
    var isSecure = false
    
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .leading, vertical: .center)) {
            Image(systemName: isSecure ? "lock" : "person")
                .font(.system(size: 24))
                .frame(width: 60, height: 60)
                .clipShape(Circle())
            
            ZStack {
                if isSecure {
                    SecureField(placeholder, text: $text)
                }
                else {
                    TextField(placeholder, text: $text)
                }
            }
            .padding(.horizontal)
            .padding(.leading, 65)
            .frame(height: 60)
            .clipShape(Capsule())
        }
        .padding(.horizontal)
    }
}
