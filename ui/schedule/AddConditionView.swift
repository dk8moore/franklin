//
//  AddConditionView.swift
//  franklin
//
//  Created by Denis Ronchese on 29/03/24.
//

import SwiftUI

struct AddConditionView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedTime: Date = Date()
    @State private var selectedLocation: String = ""
    @State private var selectedApp: String = ""
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Set a Condition"), footer: Text("Have this Schedule turn on automatically at a set time or location.")) {
                    NavigationLink { 
                        AddScheduleView()
                    } label: {
                            Label {
                                VStack(alignment: .leading) {
                                    Text("Time")
                                    Text("E.g. \"12:30–02:30\"")
                                        .font(.system(size: 12))
                                        .foregroundColor(.gray)
                                }
                            } icon: {
                                Image(systemName: "clock.fill")
                            }.labelStyle(CustomLabelStyle())
                    }
                    
                    NavigationLink {
                        AddScheduleView()
                    } label: {
                            Label {
                                VStack(alignment: .leading) {
                                    Text("Location")
                                    Text("E.g. \"When I arrive at Work\"")
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

//// Placeholder style extension for TextFields
//extension View {
//    func placeholder<Content: View>(
//        when shouldShow: Bool,
//        alignment: Alignment = .leading,
//        @ViewBuilder placeholder: () -> Content
//    ) -> some View {
//        ZStack(alignment: alignment) {
//            placeholder().opacity(shouldShow ? 1 : 0)
//            self
//        }
//    }
//}

struct AddConditionView_Previews: PreviewProvider {
    static var previews: some View {
        AddConditionView()
    }
}
