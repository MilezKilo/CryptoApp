//
//  ContentView.swift
//  CryptoApp
//
//  Created by Майлс on 09.11.2021.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            Color.colorsTheme.background.ignoresSafeArea()
            
            VStack(spacing: 40) {
                
                Text("Accent color")
                    .foregroundColor(Color.colorsTheme.accent)
                
                Text("Secondary color")
                    .foregroundColor(Color.colorsTheme.secondaryText)
                
                Text("Red Color")
                    .foregroundColor(Color.colorsTheme.red)
                
                Text("Green Color")
                    .foregroundColor(Color.colorsTheme.green)
            }
            .font(.headline)
        }
    }
}

//MARK: - PREVIEW
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().preferredColorScheme(.dark)
    }
}
