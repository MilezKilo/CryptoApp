//
//  DetailViewModel.swift
//  CryptoApp
//
//  Created by Майлс on 01.02.2022.
//

import Foundation
import Combine

class DetailViewModel: ObservableObject {
    
    @Published var overviewStatistics: [StatisticModel] = []
    @Published var additionalStatistics: [StatisticModel] = []
    @Published var coinDescription: String? = nil
    @Published var websiteURL: String? = nil
    @Published var redditURL: String? = nil

    
    @Published var coin: CoinModel
    private let coinDetailService: CoinDetailDataService
    private var cancellables = Set<AnyCancellable>()
    
    init(coin: CoinModel) {
        self.coin = coin
        self.coinDetailService = CoinDetailDataService(coin: coin)
        self.addSubscribers()
    }
    
    ///Добавляет подписчиков для наблюдения
    func addSubscribers() {
        coinDetailService.$coinDetails
            .combineLatest($coin)
            .map(mapDataToStatistics)
            .sink { [weak self] returnedArray in
                self?.overviewStatistics = returnedArray.overview
                self?.additionalStatistics = returnedArray.additional
            }
            .store(in: &cancellables)
        
        coinDetailService.$coinDetails
            .sink { [weak self] returnedCoinDetails in
                self?.coinDescription = returnedCoinDetails?.readableDescription
                self?.websiteURL = returnedCoinDetails?.links?.homepage?.first
                self?.redditURL = returnedCoinDetails?.links?.subredditURL
            }
            .store(in: &cancellables)
    }
    
    ///Метод фильтрации для map
    private func mapDataToStatistics(coinDetailModel: CoinDetailModel?, coinModel: CoinModel) -> (overview: [StatisticModel], additional: [StatisticModel]) {
        //OVERVIEW
        let overviewArray = createOverviewArray(coinModel: coinModel)
        
        //ADDITIONAL
        let additionalArray = createAdditionalArray(coinDetailModel: coinDetailModel, coinModel: coinModel)
        
        return (overviewArray, additionalArray)
    }
    
    ///Создает массив Overview данных.
    private func createOverviewArray(coinModel: CoinModel) -> [StatisticModel] {
        let price = coinModel.currentPrice.asCurrencyWith6Decimal()
        let pricePercentChange = coinModel.priceChangePercentage24H
        let priceStats = StatisticModel(title: "Current Price", value: price, percentageChange: pricePercentChange)
        
        let marketCup = "$" + (coinModel.marketCap?.formattedWithAbbreviations() ?? "")
        let marketCupPercentChange = coinModel.marketCapChangePercentage24H
        let marketCupStats = StatisticModel(title: "Market Capitalization", value: marketCup, percentageChange: marketCupPercentChange)
        
        let rank = "\(coinModel.rank)"
        let rankStats = StatisticModel(title: "Rank", value: rank)
        
        let volume = "$" + (coinModel.totalVolume?.formattedWithAbbreviations() ?? "")
        let volumeStats = StatisticModel(title: "Volume", value: volume)
        
        let overviewArray: [StatisticModel] = [priceStats, marketCupStats, rankStats, volumeStats]
        
        return overviewArray
    }
    
    ///Создает массив Additional данных.
    private func createAdditionalArray(coinDetailModel: CoinDetailModel?, coinModel: CoinModel) -> [StatisticModel] {
        
        let high = coinModel.high24H?.asCurrencyWith6Decimal() ?? "n/a"
        let highStats = StatisticModel(title: "24h high", value: high)
        
        let low = coinModel.low24H?.asCurrencyWith6Decimal() ?? "n/a"
        let lowStats = StatisticModel(title: "24h low", value: low)
        
        let priceChange = coinModel.priceChange24H?.asCurrencyWith6Decimal() ?? "n/a"
        let pricePercentChange = coinModel.priceChangePercentage24H
        let priceStatsTwo = StatisticModel(title: "24H Price Change", value: priceChange, percentageChange: pricePercentChange)
        
        let marketCupChange = "$" + (coinModel.marketCapChange24H?.formattedWithAbbreviations() ?? "")
        let marketCupPercentChange = coinModel.marketCapChangePercentage24H
        let marketCupChangeStats = StatisticModel(title: "24h Market Cup Change", value: marketCupChange, percentageChange: marketCupPercentChange)
        
        let blockTime = coinDetailModel?.blockTimeInMinutes ?? 0
        let blockTimeString = blockTime == 0 ? "n/a" : String(blockTime)
        let blockTimeStats = StatisticModel(title: "Block Time", value: blockTimeString)
        
        let hashing = coinDetailModel?.hashingAlgorithm ?? "n/a"
        let hashingStats = StatisticModel(title: "Hashing Algotithm", value: hashing)
        
        let additionalArray: [StatisticModel] = [highStats, lowStats, priceStatsTwo, marketCupChangeStats, blockTimeStats, hashingStats]
        
        return additionalArray
    }
}
