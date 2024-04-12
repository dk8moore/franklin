//
//  StateManager.swift
//  franklin
//
//  Created by Denis Ronchese on 23/03/24.
//

import SwiftUI
import Combine

class StateManager: ObservableObject {
    static let shared = StateManager()

    // Example of a user authentication state
    @Published var isAuthenticated: Bool = false
    
    // Example of current view state management
    @Published var currentView: ContentView = .main
    
    @Published var showingAddScheduleSheet: Bool = false
    
    // Enum for content views your app will display
    enum ContentView {
        case login, main, settings
    }
    
    private init() {} // Private initializer for Singleton
    
    func loginUser() {
        isAuthenticated = true
        currentView = .main
    }
    
    func logoutUser() {
        isAuthenticated = false
        currentView = .login
    }
    
    func toggleScheduleSheet() {
        showingAddScheduleSheet.toggle()
    }
    
    func showSettings() {
        currentView = .settings
    }
    
    // Add more functions here to manage state changes throughout your app
}
