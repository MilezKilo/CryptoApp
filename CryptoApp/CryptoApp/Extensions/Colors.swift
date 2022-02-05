//
//  Colors.swift
//  CryptoApp
//
//  Created by Майлс on 09.11.2021.
//

import Foundation
import SwiftUI

//Создаем расширение к существующим цветам.
extension Color {
    ///Созданные в Assets цвета как свойство типа(в данном контекста тип это цвета), доступ через точечный синтаксис.
    static let colorsTheme = ColorTheme()
    static let launchColorsTheme = LaunchColorsTheme()
}


///Структуру с цветами перечисленными в папке Assets -> ThemeColors для последующего расширения к существующим цветам.
struct ColorTheme {
    let accent = Color("AccentColor")
    let background = Color("BackgroundColor")
    let green = Color("GreenColor")
    let red = Color("RedColor")
    let secondaryText = Color("SecondaryTextColor")
}

///Структуру с цветами перечисленными в папке Assets -> LaunchThemeColors для последующего расширения к существующим цветам.
struct LaunchColorsTheme {
    
    let accent = Color("LaunchAccentColor")
    let background = Color("LaunchBackgroundColor")
}
