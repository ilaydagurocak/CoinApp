import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var coinViewModel: CoinViewModel
    @State private var searchText = ""
    
    var filteredCoins: [Coin] {
        if searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return coinViewModel.coins
        } else {
            return coinViewModel.coins.filter {
                $0.name.localizedCaseInsensitiveContains(searchText) ||
                $0.symbol.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppColors.background
                    .ignoresSafeArea()
                
                VStack(spacing: 14) {
                    HStack {
                        Text("Live Market")
                            .font(.system(size: 30, weight: .bold))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Button {
                            Task {
                                await coinViewModel.loadCoins()
                            }
                        } label: {
                            Image(systemName: "arrow.clockwise")
                                .foregroundColor(.black)
                                .padding(10)
                                .background(AppColors.yellow)
                                .clipShape(Circle())
                        }
                    }
                    .padding(.horizontal)
                    
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(AppColors.textSecondary)
                        
                        TextField("Search coins...", text: $searchText)
                            .foregroundColor(.white)
                            .autocorrectionDisabled()
                    }
                    .padding()
                    .background(AppColors.card)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .padding(.horizontal)
                    
                    if coinViewModel.isLoading && coinViewModel.coins.isEmpty {
                        Spacer()
                        ProgressView()
                            .tint(AppColors.yellow)
                        Spacer()
                    } else if !coinViewModel.errorMessage.isEmpty && coinViewModel.coins.isEmpty {
                        Spacer()
                        Text(coinViewModel.errorMessage)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                            .padding()
                        Spacer()
                    } else {
                        List {
                            ForEach(filteredCoins) { coin in
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
                        .background(Color.clear)
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

struct CoinRowView: View {
    
    let coin: Coin
    @EnvironmentObject var coinViewModel: CoinViewModel
    
    var body: some View {
        HStack(spacing: 14) {
            AsyncImage(url: URL(string: coin.image)) { image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                ProgressView()
                    .tint(.yellow)
            }
            .frame(width: 36, height: 36)
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(coin.name)
                        .foregroundColor(.white)
                        .font(.headline)
                    
                    if let rank = coin.marketCapRank {
                        Text("#\(rank)")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                
                Text(coin.symbol.uppercased())
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 6) {
                Text(coin.currentPrice.asCurrencyString())
                    .foregroundColor(.white)
                    .fontWeight(.semibold)
                
                Text((coin.priceChangePercentage24H ?? 0).asPercentString())
                    .foregroundColor((coin.priceChangePercentage24H ?? 0) >= 0 ? AppColors.green : AppColors.red)
                    .font(.caption)
                    .fontWeight(.semibold)
            }
            
            Button {
                Task {
                    await coinViewModel.toggleFavorite(for: coin.id)
                }
            } label: {
                Image(systemName: coinViewModel.isFavorite(coin.id) ? "star.fill" : "star")
                    .foregroundColor(AppColors.yellow)
                    .font(.title3)
            }
            .buttonStyle(.plain)
        }
        .padding()
        .background(AppColors.card)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .padding(.vertical, 4)
    }
}
