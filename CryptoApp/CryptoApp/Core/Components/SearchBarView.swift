//
//  SearchBarView.swift
//  CryptoApp
//
//  Created by Майлс on 28.12.2021.
//

import SwiftUI

///Шаблон поисковой строки, содержит строковое свойство привязки
struct SearchBarView: View {
    
    @Binding var searchtext: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(searchtext.isEmpty ? Color.colorsTheme.secondaryText : Color.colorsTheme.accent)
            
            TextField("Search by name, or symbol...", text: $searchtext)
                .foregroundColor(Color.colorsTheme.accent)
                .disableAutocorrection(true)
                .overlay(
                Image(systemName: "xmark.circle.fill")
                    .padding()
                    .offset(x: 10)
                    .opacity(searchtext.isEmpty ? 0.0 : 1.0)
                    .foregroundColor(Color.colorsTheme.accent)
                    .onTapGesture {
                        UIApplication.shared.endEditing()
                        searchtext = ""
                    }
                , alignment: .trailing)
        }
        .font(.headline)
        .padding()
        .background(RoundedRectangle(cornerRadius: 15)
                .fill(Color.colorsTheme.background)
                .shadow(color: Color.colorsTheme.accent.opacity(0.15), radius: 10, x: 0, y: 0))
        .padding()
    }
}

//MARK: - PREVIEW
struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBarView(searchtext: .constant(""))
            .previewLayout(.sizeThatFits)
            .preferredColorScheme(.light)
        
        SearchBarView(searchtext: .constant(""))
            .previewLayout(.sizeThatFits)
            .preferredColorScheme(.dark)
    }
}
