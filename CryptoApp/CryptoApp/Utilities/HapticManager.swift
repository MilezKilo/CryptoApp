//
//  HapticManager.swift
//  CryptoApp
//
//  Created by Майлс on 30.01.2022.
//

import SwiftUI

class HapticManager {
    
    static private var generator = UINotificationFeedbackGenerator()
    
    static func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        generator.notificationOccurred(type)
    }
}
