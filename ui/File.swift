//
//  File.swift
//  franklin
//
//  Created by Denis Ronchese on 24/03/24.
//

import SwiftUI
import FamilyControls

struct ExampleView: View {
    @State var selection = FamilyActivitySelection()


    var body: some View {
        VStack {
            Image(systemName: "eye")
                .font(.system(size: 76.0))
                .padding()


            FamilyActivityPicker(selection: $selection)


            Image(systemName: "hourglass")
                .font(.system(size: 76.0))
                .padding()
        }
        .onChange(of: selection) { newSelection in
            let applications = selection.applications
            let categories = selection.categories
            let webDomains = selection.webDomains
        }
    }
}

struct AdffdScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        ExampleView()
            .environmentObject(StateManager.shared) // Ensure StateManager is provided
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

