import SwiftUI

extension Double {
    
    private var currencyFormatter2: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
        formatter.minimumIntegerDigits = 1
        formatter.maximumFractionDigits = 2
        return formatter
    }
    
    func asCurrensyWith2Decimals() -> String {
        
        let number = NSNumber(value: self)
        guard let strCurFormatter = currencyFormatter2.string(from: number) else {
            return "0.00"
        }
        return strCurFormatter
    }
    
    
    private var currencyFormatter6: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
        formatter.minimumIntegerDigits = 1
        formatter.maximumFractionDigits = 6
        return formatter
    }
    
    func asCurrensyWith6Decimals() -> String {
        
        let number = NSNumber(value: self)
        guard let strCurFormatter = currencyFormatter6.string(from: number) else {
            return "0.00"
        }
        return strCurFormatter
    }
    
    func asNumberString() -> String {
        return String(format: "%.2f", self)
    }
    
    func  asPercenstString() -> String {
        return asNumberString() + " %"
    }
    
    func formattedWithAbbreviations() -> String {
        let num = abs(Double(self))
        let sign = (self < 0) ? "-" : ""

        switch num {
        case 1_000_000_000_000...:
            let formatted = num / 1_000_000_000_000
            let stringFormatted = formatted.asNumberString()
            return "\(sign)\(stringFormatted)Tr"
        case 1_000_000_000...:
            let formatted = num / 1_000_000_000
            let stringFormatted = formatted.asNumberString()
            return "\(sign)\(stringFormatted)Bn"
        case 1_000_000...:
            let formatted = num / 1_000_000
            let stringFormatted = formatted.asNumberString()
            return "\(sign)\(stringFormatted)M"
        case 1_000...:
            let formatted = num / 1_000
            let stringFormatted = formatted.asNumberString()
            return "\(sign)\(stringFormatted)K"
        case 0...:
            return self.asNumberString()

        default:
            return "\(sign)\(self)"
        }
    }
}
