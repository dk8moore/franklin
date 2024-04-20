//
//  AddConditionView.swift
//  franklin
//
//  Created by Denis Ronchese on 29/03/24.
//

import SwiftUI

struct AddConditionView: View {
    @Environment(\.presentationMode) var presentationMode    
    var onAddCondition: (any ConditionData) -> Void
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Set a Condition"), footer: Text("Have this Schedule turn on automatically at a set time or location.")) {
                    NavigationLink { 
                        TimeConditionView(timeCondition: nil, onSave: onAddCondition)
                    } label: {
                            Label {
                                VStack(alignment: .leading) {
                                    Text("Time")
                                    Text("E.g. \"Weekend 12:30–02:30\"")
                                        .font(.system(size: 12))
                                        .foregroundColor(.gray)
                                }
                            } icon: {
                                Image(systemName: "clock.fill")
                            }.labelStyle(CustomLabelStyle())
                    }
                    
                    NavigationLink {
                        LocationConditionView(onSave: onAddCondition)
                    } label: {
                            Label {
                                VStack(alignment: .leading) {
                                    Text("Location")
                                    Text("E.g. \"When I enter City Hall area\"")
                                        .font(.system(size: 12))
                                        .foregroundColor(.gray)
                                }
                            } icon: {
                                Image(systemName: "location.fill")
                            }.labelStyle(CustomLabelStyle())
                    }
                }
                .padding(.horizontal, -6)
            }
            .navigationBarTitle("Add Condition", displayMode: .inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
}
struct CustomLabelStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.icon
                .foregroundColor(.blue)
                .font(.system(size: 20))
                .padding(.trailing, 4)
            configuration.title
        }
        .padding(.vertical, 1)
    }
}

struct AddConditionView_Previews: PreviewProvider {
    static var previews: some View {
        AddConditionView(onAddCondition: { _ in })
    }
}
