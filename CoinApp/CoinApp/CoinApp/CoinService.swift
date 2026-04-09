import Foundation

final class CoinService {
    
    // MARK: - Fetch Coins
    func fetchCoins() async throws -> [Coin] {
        
        guard let url = URL(string:
            "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=100&page=1&sparkline=false&price_change_percentage=24h"
        ) else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              200...299 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }
        
        let decoder = JSONDecoder()
        return try decoder.decode([Coin].self, from: data)
    }
    
    
    // MARK: - Fetch Chart (FIXED VERSION)
    func fetchChartPrices(coinId: String, days: Int = 7) async throws -> [Double] {
        
        guard let url = URL(string:
            "https://api.coingecko.com/api/v3/coins/\(coinId)/market_chart?vs_currency=usd&days=\(days)"
        ) else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              200...299 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }
        
        let decoder = JSONDecoder()
        
        let chartResponse = try decoder.decode(CoinChartResponse.self, from: data)
        
        // ✅ EN TEMİZ VE HATASIZ
        return chartResponse.prices.map { $0[1] }
    }
}
