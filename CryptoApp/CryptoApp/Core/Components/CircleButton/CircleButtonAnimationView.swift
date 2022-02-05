//
//  CircleButtonAnimationView.swift
//  CryptoApp
//
//  Created by Майлс on 09.11.2021.
//

import SwiftUI

struct CircleButtonAnimationView: View {
    
    //Данное View является компонентом и содержит в себе информацию для появления и исчезания круга вокруг кнопки, считай волновую анимацию. По задумке, при переключении в состояние true, круг появляется, затем исчезает, в модификаторах описаны подробности типа "толщины круга" и "прозрачности", итд.
    
    ///Свойство привязки для передачи в другие View, при создании и инициализации этого View
    @Binding var animation: Bool
    
    var body: some View {
        Circle()
            .stroke(lineWidth: 5)
            .scale(animation ? 1.0 : 0)
            .opacity(animation ? 0.0 : 1.0)
            .animation(animation ? Animation.easeInOut(duration: 1.0) : .none)
    }
}


//MARK: - PREVIEW
struct CircleButtonAnimationView_Previews: PreviewProvider {
    static var previews: some View {
        CircleButtonAnimationView(animation: .constant(false))
            .frame(width: 100, height: 100)
            .foregroundColor(.red)
    }
}
