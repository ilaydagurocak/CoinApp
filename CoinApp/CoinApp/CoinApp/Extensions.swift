import Foundation

extension Double {
    
    func asCurrencyString() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 6
        return formatter.string(from: NSNumber(value: self)) ?? "$0.00"
    }
    
    func asPercentString() -> String {
        return String(format: "%.2f%%", self)
    }
    
    func formattedWithAbbreviations() -> String {
        let num = abs(self)
        let sign = self < 0 ? "-" : ""
        
        switch num {
        case 1_000_000_000_000...:
            let formatted = num / 1_000_000_000_000
            return "\(sign)\(String(format: "%.2f", formatted))T"
        case 1_000_000_000...:
            let formatted = num / 1_000_000_000
            return "\(sign)\(String(format: "%.2f", formatted))B"
        case 1_000_000...:
            let formatted = num / 1_000_000
            return "\(sign)\(String(format: "%.2f", formatted))M"
        case 1_000...:
            let formatted = num / 1_000
            return "\(sign)\(String(format: "%.2f", formatted))K"
        default:
            return "\(sign)\(String(format: "%.2f", num))"
        }
    }
}
