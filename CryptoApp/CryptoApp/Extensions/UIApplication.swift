//
//  UIApplication.swift
//  CryptoApp
//
//  Created by Майлс on 28.12.2021.
//

import SwiftUI

extension UIApplication {
    
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
