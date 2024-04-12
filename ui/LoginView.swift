//
//  LoginView.swift
//  franklin
//
//  Created by Denis Ronchese on 23/03/24.
//

import SwiftUI

struct LoginView: View {
    @State private var username = ""
    @State private var password = ""

    var body: some View {
        VStack {
            TextField("Username", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("Login") {
                // Handle login logic here
            }
            .padding()
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(StateManager.shared) // Ensure StateManager is provided
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
