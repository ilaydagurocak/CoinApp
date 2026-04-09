import Foundation

@MainActor
final class CoinViewModel: ObservableObject {
    
    @Published var coins: [Coin] = []
    @Published var favoriteCoinIds: Set<String> = []
    @Published var isLoading = false
    @Published var errorMessage = ""
    
    private let coinService = CoinService()
    private let favoriteService = FavoriteService()
    
    func loadInitialData() async {
        async let coinsTask: Void = loadCoins()
        async let favoritesTask: Void = loadFavorites()
        _ = await (coinsTask, favoritesTask)
    }
    
    func loadCoins() async {
        isLoading = true
        errorMessage = ""
        
        do {
            let fetchedCoins = try await coinService.fetchCoins()
            self.coins = fetchedCoins
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func loadFavorites() async {
        do {
            let ids = try await favoriteService.fetchFavorites()
            self.favoriteCoinIds = Set(ids)
        } catch {
            print("Favorites fetch error: \(error.localizedDescription)")
        }
    }
    
    func toggleFavorite(for coinId: String) async {
        do {
            if favoriteCoinIds.contains(coinId) {
                try await favoriteService.removeFavorite(coinId: coinId)
                favoriteCoinIds.remove(coinId)
            } else {
                try await favoriteService.addFavorite(coinId: coinId)
                favoriteCoinIds.insert(coinId)
            }
        } catch {
            print("Toggle favorite error: \(error.localizedDescription)")
        }
    }
    
    func isFavorite(_ coinId: String) -> Bool {
        favoriteCoinIds.contains(coinId)
    }
    
    func favoriteCoins(from source: [Coin]? = nil) -> [Coin] {
        let list = source ?? coins
        return list.filter { favoriteCoinIds.contains($0.id) }
    }
    
    func chartPrices(for coinId: String, days: Int = 7) async -> [Double] {
        do {
            return try await coinService.fetchChartPrices(coinId: coinId, days: days)
        } catch {
            print("Chart fetch error: \(error.localizedDescription)")
            return []
        }
    }
}
