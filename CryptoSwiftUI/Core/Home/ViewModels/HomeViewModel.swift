import SwiftUI
import Combine

class HomeViewModel: ObservableObject {
    
    
    @Published var statistic: [Statistic] = []
    @Published var allCoins: [Coin] = []
    @Published var portfolioCoins: [Coin] = []
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false
    @Published var sortOption: SortOption = .holdings
    
    private let coinDataService = CoinDataService()
    private let marketDataService = MarketDataService()
    private let portfolioDataService = PortfolioDataService()
    private var cancellables = Set<AnyCancellable>()
    
    enum SortOption {
        case rank, rankReversed, holdings, holdingsReversed, price, priceReversed
    }
    
    init() {
        addSubscribers()
    }
    
    func addSubscribers() {
        $searchText
            .combineLatest(coinDataService.$allCoins, $sortOption)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterAndSortCoins)
            .sink { [weak self] returnedCoins in
                self?.allCoins = returnedCoins
            }
            .store(in: &cancellables)
        
        $allCoins
            .combineLatest(portfolioDataService.$savedEntityes)
            .map(mapAllCoinsToPortfolioCoins)
            .sink { [weak self] returnedCoins in
                guard let self = self else { return }
                self.portfolioCoins = self.sortPortfolioCoinsIfNeeded(coins: returnedCoins)
            }
            .store(in: &cancellables)
        
        marketDataService.$marketData
            .combineLatest($portfolioCoins)
            .map(mapGlobalMarketData)
            .sink { [weak self] returnedStats in
                self?.statistic = returnedStats
                self?.isLoading = false
            }
            .store(in: &cancellables)
    }
    
    func updatePortfolio(coin: Coin, amount: Double) {
        portfolioDataService.updatePortfolio(coin: coin, amount: amount)
    }
    
    func reloadData() {
        isLoading = true
        coinDataService.getCoins()
        marketDataService.getData()
        HapticManager.notification(type: .success)
    }
    
    private func filterAndSortCoins(text: String, coins: [Coin], sort: SortOption) -> [Coin] {
        var updateCoins = filterCoins(text: text, coins: coins)
        sortCoins(sort: sort, coins: &updateCoins)
        return updateCoins
    }
    
    private func filterCoins(text: String, coins: [Coin]) -> [Coin] {
        guard !text.isEmpty else {
            return coins
        }
        
        let lovercasedText = text.lowercased()
        
        return coins.filter { coin in
            return coin.name.lowercased().contains(lovercasedText) ||
            coin.symbol.lowercased().contains(lovercasedText) ||
            coin.id.lowercased().contains(lovercasedText)
        }
        
    }
    
    private func sortCoins(sort: SortOption, coins: inout [Coin]) {
        switch sort {
        case .rank, .holdings:
            coins.sort { (coinOne, coinTwo)  -> Bool in
                coinOne.rank < coinTwo.rank
            }
        case .rankReversed, .holdingsReversed:
            coins.sort { (coinOne, coinTwo)  -> Bool in
                coinOne.rank > coinTwo.rank
            }
        case .price:
            coins.sort { (coinOne, coinTwo)  -> Bool in
                coinOne.currentPrice > coinTwo.currentPrice
            }
        case .priceReversed:
            coins.sort { (coinOne, coinTwo)  -> Bool in
                coinOne.currentPrice < coinTwo.currentPrice
            }
        }
    }
    
    private func sortPortfolioCoinsIfNeeded(coins: [Coin]) -> [Coin] {
        switch sortOption {
        case .holdings:
            return coins.sorted { (coinOne, coinTwo) in
                return coinOne.currentHoldingsValue > coinTwo.currentHoldingsValue
            }
        case .holdingsReversed:
            return coins.sorted { (coinOne, coinTwo) in
                return coinOne.currentHoldingsValue < coinTwo.currentHoldingsValue
            }
        default:
            return coins
        }
    }
    
    private func mapAllCoinsToPortfolioCoins(coinModels: [Coin], portfolioEntities : [PortfolioEntity]) -> [Coin] {
        coinModels
            .compactMap { coin -> Coin? in
                guard let entity = portfolioEntities.first(where: {$0.coinID == coin.id}) else {
                    return nil
                }
                return coin.updateHoldings(amount: entity.amount)
            }
    }
    
    private func mapGlobalMarketData(marketData: MarketData?, portfolioCoin: [Coin]) -> [Statistic] {
        var stats: [Statistic] = []
        
        guard let data = marketData else  {
            return stats
        }
        
        let marketCap = Statistic(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
        let volume  = Statistic(title: "24h Volume", value: data.volume, percentageChange: nil)
        let btcDominance = Statistic(title: "BTC Dominance", value: data.btcDominance, percentageChange: nil)
        
        let  portfolioValue = portfolioCoins.map { coin -> Double in
            return coin.currentHoldingsValue
        }
            .reduce(0, +)
        
        let previousValue = portfolioCoins.map { coin -> Double in
            let currentValue = coin.currentHoldingsValue
            guard let pecentChangeDouble = coin.priceChangePercentage24H else {
                return 0.0
            }
            let pecentChange = pecentChangeDouble / 100
            let previousValue = currentValue / (1 + pecentChange)
            return previousValue
        }
            .reduce(0, +)
        
        let percentageChange = ((portfolioValue - previousValue)  / previousValue) * 100
        
        let portfolio = Statistic(
            title: "Portfolio value",
            value: portfolioValue.asCurrensyWith2Decimals(),
            percentageChange: percentageChange)
        
        stats.append(contentsOf: [
            marketCap,
            volume,
            btcDominance,
            portfolio
        ])
        return stats
    }
}
