//
//  MoneyPicker.swift
//  franklin
//
//  Created by Denis Ronchese on 15/04/24.
//

import SwiftUI

struct MoneyPicker: View {
    @State private var isOnce: Bool = false
    @State private var amount: String = "1235"

    var body: some View {
        VStack {
            HStack {
                Toggle(isOn: $isOnce) {
                    // Empty view, since the label is provided by the custom toggle style
                }
                .toggleStyle(FeeToogleStyle())
            }

            HStack {
                        Image(systemName: "pencil.tip") // Icon on the left
                            .foregroundColor(.gray)
                        
                        TextField("Enter amount", text: $amount) // Text field
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: 200) // Adjust the width as necessary
                        
                        Text("/day") // Static text on the right
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, alignment: .center) // Centering the HStack in the view
            
            
//            HStack(spacing: 0) {
//                Spacer()
////                Text("$")
////                    .font(.largeTitle)
//                TextField("Amount", text: $amount)
////                    .font(.largeTitle)
//                    .keyboardType(.decimalPad)
//                    .frame(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
//                if (isOnce) {
//                    Text("/minute")
////                        .font(.title2)
//                }
////                Spacer()
//            }
//            .padding()
        }
//        .padding()
    }
}

struct FeeToogleStyle: ToggleStyle {
    var leftIcon: String = "1.circle.fill"
    var rightIcon: String = "clock.fill"
    var leftColor: Color = .blue
    var rightColor: Color = .green
    var leftLabel: String = "Once"
    var rightLabel: String = "Minutely"
    var inactiveColor: Color = Color(.systemGray3)
 
    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: 15) {
            Text(leftLabel)
                .foregroundColor(!configuration.isOn ? .black : inactiveColor)
            RoundedRectangle(cornerRadius: 30)
                .fill(configuration.isOn ? rightColor : leftColor)
                .overlay {
                    Circle()
                        .fill(.white)
                        .padding(3)
                        .overlay {
                            Image(systemName: configuration.isOn ? rightIcon : leftIcon)
                                .foregroundColor(configuration.isOn ? rightColor : leftColor)
                                .font(.system(size: 15))
                        }
                        .offset(x: configuration.isOn ? 13 : -13)
 
                }
                .frame(width: 50, height: 25)
                .onTapGesture {
                    withAnimation(.spring) {
                        configuration.isOn.toggle()
                    }
                }
            Text(rightLabel)
                .foregroundColor(configuration.isOn ? .black : inactiveColor)
        }
    }
}

struct MoneyPicker_Previews: PreviewProvider {
    static var previews: some View {
        MoneyPicker()
    }
}
