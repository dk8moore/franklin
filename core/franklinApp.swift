//
//  franklinApp.swift
//  franklin
//
//  Created by Denis Ronchese on 22/03/24.
//

import SwiftUI
import FamilyControls

@main
struct franklinApp: App {
    let persistenceController = PersistenceController.shared
    
    @AppStorage("isAuthorizedForFamilyControls") private var isAuthorizedForFamilyControls = false

    // Initialize your app
    init() {
        // Configure all UITextField instances to show the clear button while editing
        UITextField.appearance().clearButtonMode = .whileEditing
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(StateManager.shared) // State management
                .environment(\.managedObjectContext, persistenceController.container.viewContext) // Core Data context
                .onAppear {
                    requestFamilyControlsAuthorization()
                }
        }
    }

    private func requestFamilyControlsAuthorization() {
        Task {
            do {
                let authorizationCenter = AuthorizationCenter.shared
                try await authorizationCenter.requestAuthorization(for: .individual)
                // If successful, update the authorization state to true on the main thread
                DispatchQueue.main.async {
                    self.isAuthorizedForFamilyControls = true
                }
            } catch {
                DispatchQueue.main.async {
                    // Optionally handle UI update for error case
                    print("Authorization failed with error: \(error)")
                }
            }
        }
    }
}

