import SwiftUI

struct Statistic: Identifiable {
    
    let id = UUID().uuidString
    let title: String
    let value: String
    let percantageChange: Double?
    
    init(title: String, value: String, percentageChange: Double? = nil) {
        self.title = title
        self.value = value
        self.percantageChange = percentageChange
    }
}

