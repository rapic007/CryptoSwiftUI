import SwiftUI

extension PreviewProvider {
    
    static var dev: DeveloperPreview {
        return DeveloperPreview.instance
    }
}

class DeveloperPreview {
    
    static let instance = DeveloperPreview()
    private init() {}
    let coin = Coin(id: "1", symbol: "2", name: "1", image: "2", currentPrice: 2, marketCap: 2, marketCapRank: 2, fullyDilutedValuation: 2, totalVolume: 2, high24H: 2, low24H: 2, priceChange24H: 2, priceChangePercentage24H: 2, marketCapChange24H: 2, marketCapChangePercentage24H: 2, circulatingSupply: 2, totalSupply: 2, maxSupply: 2, ath: 2, athChangePercentage: 2, athDate: "2", atl: 11, atlChangePercentage: 1, atlDate: "2", lastUpdated: "2", sparklineIn7D: nil, currentHoldings: nil)
    
    let homeVm = HomeViewModel()
    
    let stat2 = Statistic(title: "Market Cap", value: "1", percentageChange: 22)
    let stat1 = Statistic(title: "Total Volume", value: "22", percentageChange: 10.1)
    let stat3 = Statistic(title: "Portfolio", value: "2", percentageChange: -12.3)
                          
}

