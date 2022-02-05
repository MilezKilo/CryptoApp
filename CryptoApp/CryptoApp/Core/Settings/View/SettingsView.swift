//
//  SettingsView.swift
//  CryptoApp
//
//  Created by Майлс on 04.02.2022.
//

import SwiftUI

struct SettingsView: View {
    
    let githubURL = URL(string: "https://github.com/MilezKilo?tab=repositories")!
    let coingeckoURL = URL(string: "https://www.coingecko.com")!
    let youtubeChannel = URL(string: "https://www.youtube.com/c/SwiftfulThinking")!
    let swiftUIDocsURL = URL(string: "https://developer.apple.com/documentation/SwiftUI")!
    let cryptoPolicy = URL(string: "https://www.coingecko.com/en/faq")!
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ZStack {
                //background layer
                Color.colorsTheme.background.ignoresSafeArea()
                
                //content layer
                List {
                    youtubeSection
                    coingeckoSection
                    developerSection
                    applicationSection
                }
            }
            .font(.headline)
            .accentColor(.blue)
            .listStyle(GroupedListStyle())
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) { xmarkButton }
            }
        }
    }
}

//MARK: - EXTENSION
extension SettingsView {
    private var youtubeSection: some View {
        Section(header: Text("Base Information")) {
            VStack(alignment: .leading) {
                Image("logo")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                Text("This app was made by following @swiftfulThinking course on youtube. It used MVVM architecture, Combine and CoreData")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(Color.colorsTheme.accent)
            }
            .padding(.vertical)
            Link("Following on youtube", destination: youtubeChannel)
        }
    }
    private var coingeckoSection: some View {
        Section(header: Text("API information")) {
            VStack(alignment: .leading) {
                Image("coingecko")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                Text("The cryptocurrency data is used in the app come from a free API from CoinGecko. Prices may be slightly delayed.")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(Color.colorsTheme.accent)
            }
            .padding(.vertical)
            Link("Visit CoinGecko", destination: coingeckoURL)
        }
    }
    private var developerSection: some View {
        Section(header: Text("Developer Info")) {
            VStack(alignment: .leading) {
                Image("github")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                Text("This app was made by Max Ponizov, it used SwiftUI, and made by 100% in Swift. Check my github info, for more projects, I hope you find something interesting for yourself!.")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(Color.colorsTheme.accent)
            }
            .padding(.vertical)
            Link("Visit my Github!", destination: githubURL)
        }
    }
    private var applicationSection: some View {
        Section(header: Text("Application")) {
            Link("Learn more about SwiftUI", destination: swiftUIDocsURL)
            Link("Crypto FAQ", destination: cryptoPolicy)
        }
    }
    
    //BUTTONS
    private var xmarkButton: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "xmark")
                .font(.headline)
        }
    }
}

//MARK: - PREVIEW
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
