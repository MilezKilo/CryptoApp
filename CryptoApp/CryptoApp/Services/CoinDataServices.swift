//
//  CoinDataServices.swift
//  CryptoApp
//
//  Created by Майлс on 10.11.2021.
//

import Foundation
import Combine

class CoinDataServices {
    
    ///Свойство, на которое будет подписываться allCoins в HomeViewModel содержит в себе все скаченные валюты с сервера.
    @Published var allCoins: [CoinModel] = []
    ///Свойство, которое получает данные о монетах с сервера
    /// ```
    /// decode - Декодирует данные типа CoinModel используя JSONDecoder()
    /// sink - Наблюдает за изменениями в данном свойстве, использует NetworkingManager.handleComplition с определенным набором кейсов действий
    /// В случае успеха возвращает данные с сервера о валюте
    /// self?.coinsSubscription?.cancel() - отменяет активные действия
    /// ```
    var coinsSubscription: AnyCancellable?
    
    init() {
        getCoins()
    }
    
    ///Метод получения JSON данных с сервера, используется только при вызове данного класса
    func getCoins() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h") else { return }
        
        coinsSubscription = NetworkingManager.download(url: url)
            .decode(type: [CoinModel].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleComplition, receiveValue: { [weak self] returnedCoins in
                self?.allCoins = returnedCoins
                self?.coinsSubscription?.cancel()
            })
    }
}
