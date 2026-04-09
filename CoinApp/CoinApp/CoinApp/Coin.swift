import Foundation

struct Coin: Identifiable, Codable {
    let id: String
    let symbol: String
    let name: String
    let image: String
    let currentPrice: Double
    let marketCapRank: Int?
    let priceChangePercentage24H: Double?
    let high24H: Double?
    let low24H: Double?
    let marketCap: Double?
    let totalVolume: Double?
    let circulatingSupply: Double?
    
    enum CodingKeys: String, CodingKey {
        case id
        case symbol
        case name
        case image
        case currentPrice = "current_price"
        case marketCapRank = "market_cap_rank"
        case priceChangePercentage24H = "price_change_percentage_24h"
        case high24H = "high_24h"
        case low24H = "low_24h"
        case marketCap = "market_cap"
        case totalVolume = "total_volume"
        case circulatingSupply = "circulating_supply"
    }
}
