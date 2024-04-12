//
//  ScheduleTileView.swift
//  franklin
//
//  Created by Denis Ronchese on 23/03/24.
//

import SwiftUI

struct ScheduleTileView: View {
    var schedule: ScheduleEntity

    var body: some View {
        HStack {
            Text(schedule.icon!)
                .font(.largeTitle)
            
            VStack(alignment: .leading) {
                Text(schedule.title!)
                    .fontWeight(.bold)
                
                HStack {
                    Circle()
                        .fill(schedule.isEnabled ? Color.green : Color.red)
                        .frame(width: 10, height: 10)
                    Text(schedule.isEnabled ? "Enabled" : "Disabled")
                        .font(.caption)
                }
            }
            
            Spacer()
            
            Button(action: {
                // Handle options (Edit, Delete, etc.)
            }) {
                Image(systemName: "ellipsis")
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(radius: 1)
    }
}

struct ScheduleTileView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(StateManager.shared) // Ensure StateManager is provided
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
