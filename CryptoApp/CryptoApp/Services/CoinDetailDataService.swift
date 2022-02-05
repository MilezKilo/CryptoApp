//
//  CoinDetailDataService.swift
//  CryptoApp
//
//  Created by Майлс on 01.02.2022.
//

import Foundation
import Combine

class CoinDetailDataService {
    
    ///Свойство, на которое будет подписываться allCoins в HomeViewModel содержит в себе все скаченные валюты с сервера.
    @Published var coinDetails: CoinDetailModel? = nil
    ///Свойство, которое получает данные о монетах с сервера
    /// ```
    /// decode - Декодирует данные типа CoinModel используя JSONDecoder()
    /// sink - Наблюдает за изменениями в данном свойстве, использует NetworkingManager.handleComplition с определенным набором кейсов действий
    /// В случае успеха возвращает данные с сервера о валюте
    /// self?.coinsSubscription?.cancel() - отменяет активные действия
    /// ```
    var coinDetailsSubscription: AnyCancellable?
    let coin: CoinModel
    
    init(coin: CoinModel) {
        self.coin = coin
        getCoindetails()
    }
    
    ///Метод получения JSON данных с сервера, используется только при вызове данного класса
    func getCoindetails() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/\(coin.id)?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false") else { return }
        
        coinDetailsSubscription = NetworkingManager.download(url: url)
            .decode(type: CoinDetailModel.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleComplition, receiveValue: { [weak self] returnedCoinDetails in
                self?.coinDetails = returnedCoinDetails
                self?.coinDetailsSubscription?.cancel()
            })
    }
}
