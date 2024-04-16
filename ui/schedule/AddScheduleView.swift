//
//  AddScheduleView.swift
//  franklin
//
//  Created by Denis Ronchese on 23/03/24.
//

import SwiftUI
import UIKit
import FamilyControls

struct AddScheduleView: View {
    @State private var sceneName: String = ""
    @State private var isPickerPresented = false
    @State private var selection = FamilyActivitySelection()
//    @State private var conditions = {}
    @State private var limitDuration = {}
    @State private var selectedTime = Date()
    @State private var conditions: [String] = []
    @State private var showDatePicker = false
    @State private var showMoneyPicker = false
    @State private var setTimeText = "Set"
    @State private var showingSheet = false;
    @State private var feeAmount = ""
    
    
    @EnvironmentObject var stateManager: StateManager
    
    
    init() {
        // Create a date representing today at 00:00
        var calendar = Calendar.current
        calendar.timeZone = TimeZone.current
        let components = calendar.dateComponents([.year, .month, .day], from: Date())
        let midnightToday = calendar.date(from: components) ?? Date()
        
        _selectedTime = State(initialValue: midnightToday)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("NAME")) {
                    HStack {
                        Image(systemName: "pencil.tip") // Example icon, adjust as needed
                            .onTapGesture {
                                // Present emoji/icon picker here
                            }
                        TextField("Schedule name", text: $sceneName)
                    }
                }

                
                Section(header: Text("APPS"), footer: Text("Select which apps do you want to lock.")) {
                    HStack {
                        Text("Selected")
                        Spacer()
//                        Text("\(selectedApps)")
                        Image(systemName: "chevron.right").bold()
                            .foregroundColor(Color(.systemGray4))
                            .font(.system(size: 13.5))
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        isPickerPresented = true
                    }
                    .familyActivityPicker(headerText: "ALL APPLICATIONS", footerText: "Select the apps or categories you want to lock.", isPresented: $isPickerPresented, selection: $selection)
                }
                
                // Here could be present an Add condition that add to the list the condition
                // When there are no conditions still, there will be just the Add Condition button, then the condition added will be listed here, but the Add Condition will remain whatsoever down
                // Conditions for now can be based on time and based on location
                // Dynamically lists conditions and provides an option to add more
              
                Section(header: Text("Usage limit"), footer: Text("Set daily limits for the locked apps. Limits reset every day at midnight.")) {
                    Button(action: {
                        // Toggle the visibility of the DatePicker
                        self.showDatePicker.toggle()
                    }) {
                        HStack {
                            Text("Time")
                                .foregroundColor(.black)
                            Spacer()
                            Text(setTimeText)
                                .foregroundColor(!showDatePicker || setTimeText == "Set" ? .gray : .blue)
                        }
                    }
                    
                    if showDatePicker {
                        DatePicker("Select Time", selection: $selectedTime, displayedComponents: .hourAndMinute)
                            .datePickerStyle(WheelDatePickerStyle())
                            .onChange(of: selectedTime) {
                                updateSetTimeText(with: selectedTime)
                            }
                    }
                }
                
                Section(header: Text("Usage fees"), footer: Text("Set fees to pay for each minute spent on the apps after the daily limit.")) {
                    Button(action: {
                        self.showMoneyPicker.toggle()
                    }) {
                        HStack {
                            Text("Money")
                                .foregroundColor(.black)
                            Spacer()
                            Text(setTimeText)
                                .foregroundColor(!showDatePicker || setTimeText == "Set" ? .gray : .blue)
                        }
                    }
                    
                    if showMoneyPicker {
                        MoneyPicker()
//                        DatePicker("Select Time", selection: $selectedTime, displayedComponents: .hourAndMinute)
//                            .datePickerStyle(WheelDatePickerStyle())
//                            .onChange(of: selectedTime) {
//                                updateSetTimeText(with: selectedTime)
//                            }
                    }
                }
                
                Section(header: Text("Conditions"), footer: Text("Set automatic activation conditions based on time or location.")) {
                    ForEach(conditions, id: \.self) { condition in
                        Text(condition)
                    }
                    .onDelete(perform: deleteCondition)
                    
                    Button(action: {
                        self.showingSheet = true
                    }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text("Add Condition")
                        }
                    }
                }
                .sheet(isPresented: $showingSheet) { // 3. This presents the modal sheet
                    // 4. Your view goes here, the one from the screenshot
                    AddConditionView() // Replace with your actual view that should appear in the sheet
                }
                
            }
            .navigationTitle("New Schedule")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel") { stateManager.toggleScheduleSheet() },
                trailing: Button("Save") { /* action */ }
                
            )
        }
    }
    
    private func addCondition() {
        // Present a view to add a new condition
        // For the sake of example, we add a dummy condition
        conditions.append("New Condition at \(Date())")
    }
        
    private func deleteCondition(at offsets: IndexSet) {
        conditions.remove(atOffsets: offsets)
    }
    
    private func updateSetTimeText(with date: Date) {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        
        var timeComponents = [String]()
        
        if hour == 1 {
            timeComponents.append("1 hr")
        } else if hour > 1 {
            timeComponents.append("\(hour) hrs")
        }
        
        if minute > 0 {
            timeComponents.append("\(minute) min")
        }
        
        setTimeText = timeComponents.isEmpty ? "Set" : timeComponents.joined(separator: ", ")
    }
}

struct AddScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        AddScheduleView()
            .environmentObject(StateManager.shared) // Ensure StateManager is provided
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

