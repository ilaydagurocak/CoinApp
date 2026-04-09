import SwiftUI

struct FavoritesView: View {
    
    @EnvironmentObject var coinViewModel: CoinViewModel
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppColors.background
                    .ignoresSafeArea()
                
                let favorites = coinViewModel.favoriteCoins()
                
                VStack {
                    
                    
                    HStack {
                        Text("Favorites")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.white)
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)
                    
                    
                    if favorites.isEmpty {
                        Spacer()
                        VStack(spacing: 12) {
                            Image(systemName: "star.slash")
                                .font(.system(size: 42))
                                .foregroundColor(AppColors.yellow)
                            
                            Text("No favorite coins yet")
                                .foregroundColor(.white)
                                .font(.headline)
                            
                            Text("Add coins to favorites from the market page.")
                                .foregroundColor(.gray)
                                .font(.subheadline)
                        }
                        Spacer()
                    } else {
                        List {
                            ForEach(favorites) { coin in
                                NavigationLink {
                                    CoinDetailView(coin: coin)
                                } label: {
                                    CoinRowView(coin: coin)
                                }
                                .listRowBackground(Color.clear)
                                .listRowSeparator(.hidden)
                            }
                        }
                        .listStyle(.plain)
                        .scrollContentBackground(.hidden)
                    }
                }
                .padding(.top, 8)
            }
            .task {
                if coinViewModel.coins.isEmpty {
                    await coinViewModel.loadInitialData()
                } else if coinViewModel.favoriteCoinIds.isEmpty {
                    await coinViewModel.loadFavorites()
                }
            }
        }
    }
}
