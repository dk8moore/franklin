//
//  SearchFieldView.swift
//  franklin
//
//  Created by Denis Ronchese on 05/04/24.
//

// SearchFieldView.swift

import SwiftUI

struct SearchFieldView: View {
    @Binding var searchText: String
    var placeholderText: String
    var leadingIcon: String = "magnifyingglass"
    var leadingIconColor: Color = .gray
    
    var body: some View {
        HStack {
            Image(systemName: leadingIcon)
                .foregroundColor(leadingIconColor)
            TextField(placeholderText, text: $searchText)
                .padding(.vertical, 8)
        }
        .padding(.horizontal, 10)
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.13)))
        .padding(.horizontal)
    }
}

struct SearchFieldView_Previews: PreviewProvider {
    static var previews: some View {
        SearchFieldView(searchText: .constant(""), placeholderText: "Search")
    }
}
