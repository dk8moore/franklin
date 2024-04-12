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
    @State private var setTimeText = "Set"
    @State private var showingSheet = false;
    
    
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
                    .familyActivityPicker(headerText: "Prova a scrivere", footerText: "Prova a scrivere ma stavolta sotto", isPresented: $isPickerPresented, selection: $selection)
                }
                
                // Here could be present an Add condition that add to the list the condition
                // When there are no conditions still, there will be just the Add Condition button, then the condition added will be listed here, but the Add Condition will remain whatsoever down
                // Conditions for now can be based on time and based on location
                // Dynamically lists conditions and provides an option to add more
              
                Section(header: Text("USAGE LIMIT"), footer: Text("Set daily limits for the blocked apps. Limits reset every day at midnight.")) {
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
                
               
                // Here will be just the insertion of a number for the money to be calculated every tot
                // seconds/multiples/minutes after the set limits => so a value for the money and a value
                // for the period of time at which the money value will be deducted
//                Section(header: Text("FINES")) {
//                    HStack {
//                        TextField("Money Amount", text: $selection.fineAmount)
//                            .keyboardType(.decimalPad)
//                        Spacer()
//                        Picker("Time Period", selection: $selection.finePeriod) {
//                            Text("Seconds").tag(FinePeriod.seconds)
//                            Text("Minutes").tag(FinePeriod.minutes)
//                        }
//                    }
//                }

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

