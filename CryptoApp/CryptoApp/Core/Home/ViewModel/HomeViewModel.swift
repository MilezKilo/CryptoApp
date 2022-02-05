//
//  HomeViewModel.swift
//  CryptoApp
//
//  Created by Майлс on 10.11.2021.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    
    @Published var statistics: [StatisticModel] = []
    
    ///Свойство, содержит в себе всю полученную с сервера базу данных по валюте
    @Published var allCoins: [CoinModel] = []
    ///Свойство, содержит в себе купленное количество валюты
    @Published var portfolioCoins: [CoinModel] = []
    ///Свойство содержащее в себе строку для поиска необходимой валюты
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false
    @Published var sortingOption: SortingOptions = .holdings
    
    ///Свойства содержащие в себе сущности моделей данных
    private let coinDataService = CoinDataServices()
    private let marketDataService = MarketDataService()
    private let portfolioDataService = PortfolioDataService()
    private var cancellebles = Set<AnyCancellable>()
    
    enum SortingOptions {
        case rank, reversedRank, holdings, reversedHoldings, price, reversedPrice
    }
    
    init() {
        addSubscribers()
    }
    
    ///Метод подписывающий allCoins и searchText на любые изменения в CoinDataServices
    ///```
    ///combineLatest - Комбинирует подписку вместе с dataService.$allCoins
    ///debounce - Публикует изменения в подписанных элементах через указанный интервал времени
    ///map - Логика фильтрации элементов, определена в методе filterCoins, так же определяет внешний вид статистических данных
    ///sink - Возвращает фильтрованную валюту/статистику
    ///```
    func addSubscribers() {
        //Обновляет валюту в allCoins
        $searchText
            .combineLatest(coinDataService.$allCoins, $sortingOption)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(sortingAndFirterCoins)
            .sink { [weak self] returnedCoins in
                self?.allCoins = returnedCoins
            }
            .store(in: &cancellebles)
        
        //Обновляет данные о валюте в портфеле
        $allCoins
            .combineLatest(portfolioDataService.$savedEntities)
            .map(filterPortfolio)
            .sink { [weak self] returnedCoins in
                guard let self = self else { return }
                self.portfolioCoins = self.sortingPortfolioCoinsIfNeeded(coins: returnedCoins)
            }
            .store(in: &cancellebles)
        
        //Обновляет рыночные данные в statistics
        marketDataService.$marketData
            .combineLatest($portfolioCoins)
            .map(mapGlobalMarketData)
            .sink { [weak self] returnedStats in
                self?.statistics = returnedStats
                self?.isLoading = false
            }
            .store(in: &cancellebles)
        
        
    }
    
    ///Метод добавляющий валюту в портфель
    func updatePortfolio(coin: CoinModel, amount: Double) {
        portfolioDataService.updatePortfolio(coin: coin, amount: amount)
    }
    
    ///Метод обновления стоймости валюты
    func reloadData() {
        isLoading = true
        coinDataService.getCoins()
        marketDataService.getData()
        HapticManager.notification(type: .success)
    }
    
    ///Метод фильтрования и сортировки валюты
    private func sortingAndFirterCoins(text: String, coins: [CoinModel], sorting: SortingOptions) -> [CoinModel] {
        var updatedCoins = filterCoins(text: text, coins: coins)
        sortingCoins(sorting: sorting, coins: &updatedCoins)
        
        return updatedCoins
    }
    
    ///Метод фильтрования валюты
    private func filterCoins(text: String, coins: [CoinModel]) -> [CoinModel] {
        guard !text.isEmpty else { return coins }
        let lowercasedText = text.lowercased()
        return coins.filter { coin -> Bool in
            return coin.name.lowercased().contains(lowercasedText) ||
            coin.symbol.lowercased().contains(lowercasedText) ||
            coin.id.lowercased().contains(lowercasedText)
        }
    }
    
    ///Метод сортировки валюты
    private func sortingCoins(sorting: SortingOptions, coins: inout [CoinModel]) {
        switch sorting {
        case .rank, .holdings:
            coins.sort(by: { $0.rank < $1.rank })
        case .reversedRank, .reversedHoldings:
            coins.sort(by: { $0.rank > $1.rank })
        case .price:
            coins.sort(by: { $0.currentPrice < $1.currentPrice })
        case .reversedPrice:
            coins.sort(by: { $0.currentPrice > $1.currentPrice })
        }
    }
    
    ///
    private func sortingPortfolioCoinsIfNeeded(coins: [CoinModel]) -> [CoinModel] {
        switch sortingOption {
        case .holdings:
            return coins.sorted(by: { $0.currentHoldingsValue > $1.currentHoldingsValue })
        case .reversedHoldings:
            return coins.sorted(by: { $0.currentHoldingsValue < $1.currentHoldingsValue})
        default:
            return coins
        }
    }
    
    //Метод фильтрования валюты в портфеле
    private func filterPortfolio(allCoins: [CoinModel], portfolioEntities: [PortfolioEntity]) -> [CoinModel] {
        allCoins
            .compactMap { coin -> CoinModel? in
                guard let entity = portfolioEntities.first(where: { $0.coinID == coin.id }) else {
                    return nil
                }
                return coin.updateHoldings(amount: entity.amount)
            }
    }
    
    ///Метод фильтрования рыночных данных
    private func mapGlobalMarketData(marketDataModel: MarketDataModel?, portfolioCoins: [CoinModel]) -> [StatisticModel] {
        var stats: [StatisticModel] = []
        
        guard let data = marketDataModel else { return stats }
        
        let marketCap = StatisticModel(title: "Market Cap", value: data.marketCup, percentageChange: data.marketCapChangePercentage24HUsd)
        let volume = StatisticModel(title: "24h Volume", value: data.volume)
        let btcDominance = StatisticModel(title: "BTC Dominance", value: data.btcDominance)
        
        let portfolioValue = portfolioCoins
            .map({ $0.currentHoldingsValue})
            .reduce(0, +)
        
        let previousValue = portfolioCoins
            .map { coin -> Double in
                let currentValue = coin.currentHoldingsValue
                let percentChange = coin.priceChangePercentage24H ?? 0 / 100
                let previousValue = currentValue / (1 + percentChange)
                return previousValue
            }
            .reduce(0, +)
        
        let percentageChange = ((portfolioValue - previousValue) / previousValue)
        
        let portfolio = StatisticModel(title: "Portfolio Value", value: portfolioValue.asCurrencyWith2Decimal(), percentageChange: percentageChange)
        
        stats.append(contentsOf: [marketCap, volume, btcDominance, portfolio])
        
        return stats
    }
    
}
