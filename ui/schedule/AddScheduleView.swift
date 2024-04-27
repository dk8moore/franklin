//
//  AddScheduleView.swift
//  franklin
//
//  Created by Denis Ronchese on 23/03/24.
//

import SwiftUI
import UIKit
import FamilyControls
import MCEmojiPicker

struct CadencyItem {
    let menuTitle: String
    let displayTitle: String
}

struct AddScheduleView: View {
    @State private var selectedEmoji: String = "📚";
    @State private var scheduleName: String = ""
    @State private var appSelection = FamilyActivitySelection()
    @State private var usageLimit = Date()
    @State private var displayedUsageLimit = "No time"
    @State private var feeAmount: String = ""
    @State private var conditions: [any ConditionData] = []
    
    @State private var emojiPickerPresented = false;
    @State private var showAppPicker = false
    @State private var showUsageLimitPicker = false
    @State private var showAddConditionSheet = false;
    
    let cadencyItems: [CadencyItem] = [
        CadencyItem(menuTitle: "Once", displayTitle: "Once"),
        CadencyItem(menuTitle: "Every second", displayTitle: "per 1s"),
        CadencyItem(menuTitle: "Every 10 seconds", displayTitle: "per 10s"),
        CadencyItem(menuTitle: "Every 30 seconds", displayTitle: "per 30s"),
        CadencyItem(menuTitle: "Every minute", displayTitle: "per 1 min"),
        CadencyItem(menuTitle: "Every 5 minutes", displayTitle: "per 5 min")
    ]
    
    @EnvironmentObject var stateManager: StateManager
    
    
    init() {
        // Create a date representing today at 00:00
        var calendar = Calendar.current
        calendar.timeZone = TimeZone.current
        let components = calendar.dateComponents([.year, .month, .day], from: Date())
        let midnightToday = calendar.date(from: components) ?? Date()
        
        _usageLimit = State(initialValue: midnightToday)
    }
    
    var body: some View {
        NavigationView {
            Form {
                NameSectionView(selectedEmoji: $selectedEmoji, scheduleName: $scheduleName)
                AppSectionView(showAppPicker: $showAppPicker, appSelection: $appSelection)
                UsageLimitSectionView(showUsageLimitPicker: $showUsageLimitPicker, usageLimit: $usageLimit, displayedUsageLimit: $displayedUsageLimit)
                FeeSectionView(feeAmount: $feeAmount, cadencyItems: cadencyItems)
                ConditionsSectionView(conditions: $conditions, showAddConditionSheet: $showAddConditionSheet)
            }
            .navigationTitle("New Schedule")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel") { stateManager.toggleScheduleSheet() },
                trailing: Button("Save") {
                    
                }
            )
        }
    }
}

struct NameSectionView: View {
    @Binding var selectedEmoji: String
    @Binding var scheduleName: String
    @State private var emojiPickerPresented: Bool = false

    var body: some View {
        Section(header: Text("NAME"), footer: Text("Select an icon and insert a name for this schedule.")) {
            HStack {
                Button(selectedEmoji) {
                    emojiPickerPresented.toggle()
                }
                .emojiPicker(isPresented: $emojiPickerPresented, selectedEmoji: $selectedEmoji)

                TextField("Schedule name", text: $scheduleName)
            }
        }
    }
}

struct AppSectionView: View {
    @Binding var showAppPicker: Bool
    var appSelection: Binding<FamilyActivitySelection>

    var body: some View {
        Section(header: Text("APPS"), footer: Text("Select which apps do you want to lock.")) {
            HStack {
                Text("Selected")
                Spacer()
                Image(systemName: "chevron.right").bold()
                    .foregroundColor(Color(.systemGray4))
                    .font(.system(size: 13.5))
            }
            .contentShape(Rectangle())
            .onTapGesture {
                showAppPicker = true
            }
            .familyActivityPicker(headerText: "ALL APPLICATIONS", footerText: "Select the apps or categories you want to lock.", isPresented: $showAppPicker, selection: appSelection)
        }
    }
}

struct UsageLimitSectionView: View {
    @Binding var showUsageLimitPicker: Bool
    @Binding var usageLimit: Date
    @Binding var displayedUsageLimit: String

    var body: some View {
        Section(header: Text("Usage limit"), footer: Text("Set daily limits for the locked apps. Limits reset every day at midnight.")) {
            Button(action: {
                self.showUsageLimitPicker.toggle()
            }) {
                HStack {
                    Text("Set time")
                        .foregroundColor(.black)
                    Spacer()
                    Text(displayedUsageLimit)
                        .foregroundColor(!showUsageLimitPicker || displayedUsageLimit == "No time" ? .gray : .blue)
                }
            }
            
            if showUsageLimitPicker {
                DatePicker("Select Time", selection: $usageLimit, displayedComponents: .hourAndMinute)
                    .datePickerStyle(WheelDatePickerStyle())
                    .onChange(of: usageLimit) {
                        updateSetTimeText(with: usageLimit)
                    }
            }
        }
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
        
        displayedUsageLimit = timeComponents.isEmpty ? "No time" : timeComponents.joined(separator: ", ")
    }
}

struct FeeSectionView: View {
    @Binding var feeAmount: String
    @State private var selectedCadency = 0
    let cadencyItems: [CadencyItem]

    var body: some View {
        Section(header: Text("Usage fees"), footer: Text("Set the fee to pay to unlock the apps after the daily limit.")) {
            HStack {
                Image(systemName: "dollarsign.square.fill")
                    .foregroundColor(.blue)
                    .font(.system(size: 24))
                    .onTapGesture {
                        // Present currency change menu
                    }
                TextField("Amount", text: $feeAmount)
                    .keyboardType(.decimalPad)
                Spacer()
                Menu {
                    Picker("", selection: $selectedCadency) {
                        ForEach(cadencyItems.indices, id: \.self) { index in
                            Text(cadencyItems[index].menuTitle).tag(index)
                        }
                    }
                } label: {
                    Text(cadencyItems[selectedCadency].displayTitle)
                    Image(systemName: "chevron.up.chevron.down")
                        .font(.system(size: 13))
                        .padding(.leading, -4)
                }
            }
        }
    }
}

struct ConditionsSectionView: View {
    @Binding var conditions: [any ConditionData]
    @Binding var showAddConditionSheet: Bool
    var onSave: ((any ConditionData) -> Void)?

    var body: some View {
        Section(header: Text("Conditions"), footer: Text("Set automatic activation conditions based on time or location.")) {
            List {
                ForEach(conditions, id: \.id) { condition in
                    if let timeCondition = condition as? TimeConditionData {
                        NavigationLink(destination: TimeConditionView(timeCondition: timeCondition, onSave: { updatedCondition in
                            updateCondition(updatedCondition)
                        })) {
                            conditionLabel(timeCondition)
                        }
                    } else if let locationCondition = condition as? LocationConditionData {
                        NavigationLink(destination: LocationConditionView(locationCondition: locationCondition, onSave: { updatedCondition in
                            updateCondition(updatedCondition)
                        })) {
                            conditionLabel(locationCondition)
                        }
                    }
                }
                .onDelete(perform: deleteCondition)
            }

            Button(action: {
                self.showAddConditionSheet = true
            }) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("Add Condition")
                }
            }
            .sheet(isPresented: $showAddConditionSheet) {
                AddConditionView(onAddCondition: { conditionData in
                    conditions.append(conditionData)
                    showAddConditionSheet = false
                })
            }
        }
    }

    private func updateCondition(_ condition: any ConditionData) {
        if let index = conditions.firstIndex(where: { $0.id == condition.id }) {
            conditions[index] = condition
        }
        showAddConditionSheet = false
    }

    private func deleteCondition(at offsets: IndexSet) {
        conditions.remove(atOffsets: offsets)
    }

    private func conditionLabel(_ condition: any ConditionData) -> some View {
        var upperText = ""
        var lowerText = ""
        var icon = ""
        
        if let timeCondition = condition as? TimeConditionData {
            upperText = timeCondition.startTime.formatted(.dateTime.hour().minute()) + " - " + timeCondition.endTime.formatted(.dateTime.hour().minute())
            lowerText = timeCondition.selectedDaysDescription
            icon = "clock.fill"
        } else if let locationCondition = condition as? LocationConditionData {
            upperText = locationCondition.location.placemark.name ?? "Unknown Place"
            lowerText = "While at this location"
            icon = "location.fill"
        }
        
        return Label {
            VStack(alignment: .leading) {
                Text(upperText)
                    .lineLimit(1)
                    .truncationMode(.tail)
                Text(lowerText)
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
            }
        } icon: {
            Image(systemName: icon)
        }
        .labelStyle(CustomLabelStyle())
    }

}

struct AddScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        AddScheduleView()
            .environmentObject(StateManager.shared) // Ensure StateManager is provided
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

