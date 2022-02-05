//
//  MarketDataService.swift
//  CryptoApp
//
//  Created by Майлс on 22.01.2022.
//

import Foundation
import Combine

class MarketDataService {
    
    @Published var marketData: MarketDataModel? = nil
    ///Свойство, которое получает данные об изменениях в доминирующей валюте с сервера
    /// ```
    /// decode - Декодирует данные типа GlobalData используя JSONDecoder()
    /// sink - Наблюдает за изменениями в данном свойстве, использует NetworkingManager.handleComplition с определенным набором кейсов действий
    /// В случае успеха возвращает данные с сервера о валюте
    /// self?.marketDataSubscription?.cancel() - отменяет активные действия
    /// ```
    var marketDataSubscription: AnyCancellable?
    
    init() {
        getData()
    }
    
    ///Метод получения JSON данных с сервера, используется только при вызове данного класса
    func getData() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/global") else { return }
        
        marketDataSubscription = NetworkingManager.download(url: url)
            .decode(type: GlobalData.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleComplition, receiveValue: { [weak self] returnedGlobalData in
                self?.marketData = returnedGlobalData.data
                self?.marketDataSubscription?.cancel()
            })
    }
}
