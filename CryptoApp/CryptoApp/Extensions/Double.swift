//
//  Double.swift
//  CryptoApp
//
//  Created by Майлс on 09.11.2021.
//

import Foundation

extension Double {
    
    /// Конвертирует число Double  в валюту с 2 числами после плавающей точки
    /// ```
    /// Конвертирует 1234.56 в $1,234.56
    /// ```
    private var currencyFormatter2: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
//        formatter.locale = .current // <- default value
//        formatter.currencyCode = "usd" // <- change currency
        formatter.currencySymbol = "$" // <- change currency symbol
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }
    
    /// Конвертирует число Double  в валюту приведенную как строку с 2 числами после плавающей точки
    /// ```
    /// Конвертирует 1234.56 в "$1,234.56"
    /// ```
    func asCurrencyWith2Decimal() -> String {
        let number = NSNumber(value: self)
        return currencyFormatter2.string(from: number) ?? "$0.00"
    }
    
    /// Конвертирует число Double  в валюту с 2-5 числами после плавающей точки
    /// ```
    /// Конвертирует 1234.56 в $1,234.56
    /// Конвертирует 12.3456 в $12.3456
    /// Конвертирует 0.123456 в $0.123456
    /// ```
    private var currencyFormatter6: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
//        formatter.locale = .current // <- default value
//        formatter.currencyCode = "usd" // <- change currency
        formatter.currencySymbol = "$" // <- change currency symbol
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 6
        return formatter
    }
    
    /// Конвертирует число Double  в валюту приведенную как строку с 2-5 числами после плавающей точки
    /// ```
    /// Конвертирует 1234.56 в "$1,234.56"
    /// Конвертирует 12.3456 в "$12.3456"
    /// Конвертирует 0.123456 в "$0.123456"
    /// ```
    func asCurrencyWith6Decimal() -> String {
        let number = NSNumber(value: self)
        return currencyFormatter6.string(from: number) ?? "$0.00"
    }
    
    /// Конвертирует число Double  в сроковое предствавление.
    /// ```
    /// Конвертирует 1.2345 в "1.23"
    ///
    /// ```
    func asNumberAsString() -> String {
        return String(format: "%.2f", self)
    }
    
    /// Конвертирует число Double  в сроковое предствавление со знаком процента.
    /// ```
    /// Конвертирует 1.2345 в "1.23%"
    ///
    /// ```
    func asPercentString() -> String {
        return asNumberAsString() + "%"
    }
    
    /// Конвертирует число Double в строку с K, M, Bn, Tr аббревиатурами.
    /// ```
    /// Конвертирует 12 to 12.00
    /// Конвертирует 1234 to 1.23K
    /// Конвертирует 123456 to 123.45K
    /// Конвертирует 12345678 to 12.34M
    /// Конвертирует 1234567890 to 1.23Bn
    /// Конвертирует 123456789012 to 123.45Bn
    /// Конвертирует 12345678901234 to 12.34Tr
    /// ```
    func formattedWithAbbreviations() -> String {
        let num = abs(Double(self))
        let sign = (self < 0) ? "-" : ""

        switch num {
        case 1_000_000_000_000...:
            let formatted = num / 1_000_000_000_000
            let stringFormatted = formatted.asNumberAsString()
            return "\(sign)\(stringFormatted)Tr"
        case 1_000_000_000...:
            let formatted = num / 1_000_000_000
            let stringFormatted = formatted.asNumberAsString()
            return "\(sign)\(stringFormatted)Bn"
        case 1_000_000...:
            let formatted = num / 1_000_000
            let stringFormatted = formatted.asNumberAsString()
            return "\(sign)\(stringFormatted)M"
        case 1_000...:
            let formatted = num / 1_000
            let stringFormatted = formatted.asNumberAsString()
            return "\(sign)\(stringFormatted)K"
        case 0...:
            return self.asNumberAsString()

        default:
            return "\(sign)\(self)"
        }
    }
}
