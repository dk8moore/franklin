//
//  TimeConditionView.swift
//  franklin
//
//  Created by Denis Ronchese on 29/03/24.
//

import SwiftUI

struct TimeConditionView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var startTime = Date()
    @State private var endTime = Date()
    @State private var selectedDays: [Bool]
    
    var timeCondition: TimeConditionData?
    var onSave: (any ConditionData) -> Void
    
    init(timeCondition: TimeConditionData? = nil, onSave: @escaping (any ConditionData) -> Void) {
        self.onSave = onSave
        self.timeCondition = timeCondition
        
        if let data = timeCondition {
            _startTime = State(initialValue: data.startTime)
            _endTime = State(initialValue: data.endTime)
            _selectedDays = State(initialValue: data.selectedDays)
        } else {
            // Default initialization for new conditions
            var calendar = Calendar.current
            calendar.timeZone = TimeZone.current
            var components = calendar.dateComponents([.year, .month, .day], from: Date())
            components.hour = 9
            components.minute = 0
            let nineAMToday = calendar.date(from: components) ?? Date()
            
            _startTime = State(initialValue: nineAMToday)
            _endTime = State(initialValue: nineAMToday.addingTimeInterval(60*60*8))
            _selectedDays = State(initialValue: Array(repeating: true, count: 7))
        }
    }

    var body: some View {
        Form {
            Section(header: Text("TIME"), footer: Text(selectedDaysDescription)) {
                DatePicker("From", selection: $startTime, displayedComponents: .hourAndMinute)
                DatePicker("To", selection: $endTime, displayedComponents: .hourAndMinute)
                HStack {
                    ForEach(0..<selectedDays.count, id: \.self) { index in
                        DayToggle(isSelected: $selectedDays[index], title: dayTitle(index))
                    }
                }
                .frame(minWidth: 0, maxWidth: .infinity)
            }
        }
        .navigationTitle("Time")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: Button("Save") {
            let data = TimeConditionData(id: timeCondition?.id ?? UUID(), startTime: startTime, endTime: endTime, selectedDays: selectedDays, selectedDaysDescription: selectedDaysDescription)
            onSave(data)
            presentationMode.wrappedValue.dismiss()
        }
        .disabled(isConditionUnchanged()))
    }
    
    func dayTitle(_ index: Int) -> String {
        // Same dayTitle function as before
        ["M", "T", "W", "T", "F", "S", "S"][index]
    }
}

struct DayToggle: View {
    @Binding var isSelected: Bool
    var title: String
    
    var body: some View {
        Button(action: {
            self.isSelected.toggle()
        }) {
            Text(title)
                .frame(width: 35, height: 35)
                .font(.system(size: 17))
                .foregroundColor(isSelected ? .white : .blue)
                .background(isSelected ? Color.blue : Color.clear) // Use clear color for non-selected
                .clipShape(Circle()) // This will clip the background to a circle
        }
        .buttonStyle(PlainButtonStyle()) // Ensures the button style doesn't interfere with the layout

    }
}

extension TimeConditionView {
    var selectedDaysDescription: String {
        let daysFull = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
        let selectedDaysIndices = selectedDays.enumerated().filter({ $0.element }).map({ $0.offset })

        // Define special cases
        if selectedDaysIndices.isEmpty {
            return "Never repeats"
        } else if selectedDaysIndices.count == 7 {
            return "Every day"
        } else if selectedDaysIndices.allSatisfy({ $0 < 5 }) && selectedDaysIndices.count == 5 {
            return "Weekdays"
        } else if selectedDaysIndices.allSatisfy({ $0 >= 5 }) && selectedDaysIndices.count == 2 {
            return "Weekend"
        } else {
            // Handle generic case
            let selectedNames = selectedDaysIndices.map { daysFull[$0] }
            if selectedNames.count == 1 {
                return "Every \(selectedNames.first!)"
            } else {
                let formattedNames = selectedNames.dropLast().joined(separator: ", ") +
                                     ", and \(selectedNames.last!)"
                return "Every \(formattedNames)"
            }
        }
    }
}

extension TimeConditionView {
    private func isConditionUnchanged() -> Bool {
        guard let original = timeCondition else { return false }
        let areTimesSame = original.startTime == startTime && original.endTime == endTime
        let areDaysSame = original.selectedDays == selectedDays
        return areTimesSame && areDaysSame
    }
}

struct TimeConditionView_Previews: PreviewProvider {
    static var previews: some View {
        TimeConditionView(onSave: { _ in })
    }
}
