//
//  CircleButtonView.swift
//  CryptoApp
//
//  Created by Майлс on 09.11.2021.
//

import SwiftUI

struct CircleButtonView: View {
    
    //Данное View является компонентом и содержит в себе информацию для создания кнопки по шаблону.
    
    //Создаем константу, для последющей передачи иконки при создании
    let iconName: String
    
    var body: some View {
        Image(systemName: iconName)
            .font(.headline)
            .foregroundColor(Color.colorsTheme.accent)
            .frame(width: 50, height: 50)
            .background(Circle().foregroundColor(Color.colorsTheme.background))
            .shadow(color: Color.colorsTheme.accent.opacity(0.25), radius: 10, x: 0, y: 0)
            .padding()
    }
}

//MARK: - PREVIEW
struct CircleButtonView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CircleButtonView(iconName: "info")
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.light)
            
            CircleButtonView(iconName: "plus")
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
        }
    }
}
