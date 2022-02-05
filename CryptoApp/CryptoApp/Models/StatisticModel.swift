//
//  StatisticModel.swift
//  CryptoApp
//
//  Created by Майлс on 21.01.2022.
//

import Foundation

///Структура содержащая в себе данные об компоненте подзаголовочного файла
struct StatisticModel: Identifiable {
    let id = UUID().uuidString
    let title: String
    let value: String
    let percentageChange: Double?
    
    init(title: String, value: String, percentageChange: Double? = nil) {
        self.title = title
        self.value = value
        self.percentageChange = percentageChange
    }
}
