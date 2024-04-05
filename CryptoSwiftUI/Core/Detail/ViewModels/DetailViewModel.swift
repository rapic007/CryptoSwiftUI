import SwiftUI
import Combine

class DetailViewModel: ObservableObject {
    
    @Published var overViewStatistics: [Statistic] = []
    @Published var additionalStaistics: [Statistic] = []
    @Published var  coin: Coin
    
    
    private let coinDetailService: CoinDetailDataService
    private var cancellables = Set<AnyCancellable>()
    
    init(coin: Coin) {
        self.coin = coin
        self.coinDetailService = CoinDetailDataService(coin: coin)
        self.addSuscribers()

    }
    
    private func addSuscribers() {
        coinDetailService.$coinDetails
            .combineLatest($coin)
            .map(mapDataToStatistics)
            .sink { [weak self] returnedArrays in
                self?.overViewStatistics = returnedArrays.overView
                self?.additionalStaistics = returnedArrays.additional
            }
            .store(in: &cancellables)
    }
    
    private func mapDataToStatistics(detail: CoinDetail?, coin: Coin) -> (overView: [Statistic], additional: [Statistic]) {
        let overviewArray = createOverViewArray(coin: coin)
        let additionalArray = createAdditionalViewArray(coin: coin, detail: detail)
        
        return (overviewArray, additionalArray)
    }
    
    func createOverViewArray(coin: Coin) -> [Statistic] {
        
        let price = coin.currentPrice.asCurrensyWith6Decimals()
        let pricePercentChange = coin.priceChangePercentage24H
        let priceStat = Statistic(title: "Current Price ", value: price, percentageChange: pricePercentChange)
        
        let marketCap = "$" + (coin.marketCap?.formattedWithAbbreviations() ?? "")
        let marketCapPercentChange = coin.marketCapChangePercentage24H
        let marketCapStat  = Statistic(title: "Market Capitalization", value: marketCap, percentageChange: marketCapPercentChange)
        
        let rank = "\(coin.rank)"
        let rankStat = Statistic(title: "Rank", value: rank)
        
        let volume = "$" + (coin.totalVolume?.formattedWithAbbreviations() ?? "")
        let volumeStat = Statistic(title: "Volume", value: volume)
        
        let overviewArray: [Statistic] = [
            priceStat, marketCapStat, rankStat, volumeStat
        ]
        return overviewArray
    }
    
    func createAdditionalViewArray(coin: Coin, detail: CoinDetail?) -> [Statistic] {
        
        let high = coin.high24H?.asCurrensyWith6Decimals() ?? "n/a"
        let highStat = Statistic(title: "24h High", value: high)
        
        let low = coin.low24H?.asCurrensyWith6Decimals() ?? "n/a"
        let lowStat = Statistic(title: "24h Low", value: low)
        
        let priceChange = coin.priceChangePercentage24H?.asCurrensyWith6Decimals() ?? "n/a"
        let pricePercentChange  = coin.priceChangePercentage24H
        let priceChangeStat = Statistic(title: "24h Price Change", value: priceChange, percentageChange: pricePercentChange)
        
        let marketCapChange = "S" + (coin.marketCapChange24H?.formattedWithAbbreviations() ?? "")
        let marketCapPercentChange = coin.marketCapChangePercentage24H
        let marketCapCnangeStat = Statistic(title: "24h markep Cap Change", value: marketCapChange, percentageChange: marketCapPercentChange)
        
        let blockTime = detail?.blockTimeInMinutes ?? 0
        let blockTimeString = blockTime == 0 ? "n/a" : "\(blockTime)"
        let blockStat = Statistic(title: "Block Time", value: blockTimeString)
        
        let hashing = detail?.hashingAlgorithm ?? "n/a"
        let hashingStat = Statistic(title: "Hashing Algoritm", value: hashing)
        
        let additionalArray: [Statistic] = [
            highStat, lowStat, priceChangeStat, marketCapCnangeStat, blockStat, hashingStat
        ]
        return additionalArray
    }
}
