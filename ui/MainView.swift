//
//  MainView.swift
//  franklin
//
//  Created by Denis Ronchese on 23/03/24.
//

import SwiftUI
import UIKit

struct MainView: View {
    @EnvironmentObject var stateManager: StateManager
    
    @FetchRequest(
        entity: ScheduleEntity.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \ScheduleEntity.title, ascending: true)
        ]
    ) var schedules: FetchedResults<ScheduleEntity>
    
    var body: some View {
        NavigationView {
            VStack {

                if schedules.isEmpty {
                    // Show message and image if there are no schedules
                    Spacer()
                    Image(systemName: "lock.fill") // Placeholder for the app icon
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                        .foregroundColor(.blue)

                    Text("Start by creating a schedule")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding(.top, 8)

                    Text("Select the app you want to block and add conditions to them.")
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .padding()
                    Spacer()
                } else {
                    // Show schedules if there are any
                    ForEach(schedules) { schedule in
                        ScheduleTileView(schedule: schedule)
                    }
                    Spacer()
                }

            }
            .padding()
//            .navigationBarTitle("Schedules", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                stateManager.showSettings()
            }) {
                Image(systemName: "gearshape.circle.fill")
            })
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    Button(action: {
                        stateManager.toggleScheduleSheet()
                    }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text("New Schedule").bold()
                        }
                        .foregroundColor(.blue) // Use your theme color here
                    }
                    Spacer()
                }
            }
            .fullScreenCover(isPresented: $stateManager.showingAddScheduleSheet) {
                AddScheduleView().environmentObject(stateManager)
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(StateManager.shared) // Ensure StateManager is provided
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

