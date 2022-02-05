//
//  Date.swift
//  CryptoApp
//
//  Created by Майлс on 03.02.2022.
//

import Foundation

extension Date {
    
    //2021-03-13T20:49:26.606Z
    init(coinGeckoString: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSS"
        let date = formatter.date(from: coinGeckoString) ?? Date()
        self.init(timeInterval: 0, since: date)
    }
    
    private var shortFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }
    
    func dateAsString() -> String {
        return shortFormatter.string(from: self)
    }
}
