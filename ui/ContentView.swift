//
//  ContentView.swift
//  franklin
//
//  Created by Denis Ronchese on 22/03/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var stateManager: StateManager
    
    var body: some View {
        switch stateManager.currentView {
        case .login:
            LoginView()
        case .main:
            MainView()
        case .settings:
            SettingsView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(StateManager.shared) // Ensure StateManager is provided
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
