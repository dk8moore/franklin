//
//  SettingsView.swift
//  franklin
//
//  Created by Denis Ronchese on 23/03/24.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var stateManager: StateManager
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    NavigationLink(destination: Text("Premium Features")) {
                        HStack {
                            Image(systemName: "diamond.fill") // Placeholder icon
                            Text("Premium")
                        }
                    }
                    NavigationLink(destination: Text("Redeem Code")) {
                        HStack {
                            Image(systemName: "gift.fill") // Placeholder icon
                            Text("Redeem")
                        }
                    }
                    NavigationLink(destination: Text("Restore Purchases")) {
                        HStack {
                            Image(systemName: "arrow.clockwise.circle.fill") // Placeholder icon
                            Text("Restore purchases")
                        }
                    }
                    NavigationLink(destination: Text("Invite a Friend")) {
                        HStack {
                            Image(systemName: "person.fill.badge.plus") // Placeholder icon
                            Text("Invite a friend")
                        }
                    }
                }
                
                Section {
                    NavigationLink(destination: Text("Statistics")) {
                        HStack {
                            Image(systemName: "chart.bar.fill") // Placeholder icon
                            Text("Statistics")
                            Spacer()
                            Text("BETA") // This is to mimic the beta label in the screenshot
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.blue)
                                .padding(4)
                                .background(Color(UIColor.systemGray5))
                                .cornerRadius(5)
                        }
                    }
                    NavigationLink(destination: Text("Academy")) {
                        HStack {
                            Image(systemName: "graduationcap.fill") // Placeholder icon
                            Text("Academy")
                        }
                    }
                }
                
                // ... Repeat for the other sections
                
            }
            .listStyle(InsetGroupedListStyle())
            .navigationBarItems(trailing: Button("Sign in") {
                // Action for sign in
            })
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(StateManager.shared) // Ensure StateManager is provided
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
