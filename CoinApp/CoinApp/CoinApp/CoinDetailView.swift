import SwiftUI
import Charts

struct CoinDetailView: View {
    
    let coin: Coin
    @EnvironmentObject var coinViewModel: CoinViewModel
    
    @State private var chartPrices: [Double] = []
    @State private var selectedDays = 7
    @State private var isLoadingChart = false
    
    private let dayOptions = [1, 7, 30]
    
    var body: some View {
        ZStack {
            AppColors.background
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    topHeader
                    
                    priceCard
                    
                    chartSection
                    
                    statsSection
                }
                .padding()
            }
        }
        .navigationTitle(coin.name)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await loadChart()
        }
    }
    
    private var topHeader: some View {
        HStack(spacing: 14) {
            AsyncImage(url: URL(string: coin.image)) { image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                ProgressView()
                    .tint(.yellow)
            }
            .frame(width: 48, height: 48)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(coin.name)
                    .foregroundColor(.white)
                    .font(.title2.bold())
                
                Text(coin.symbol.uppercased())
                    .foregroundColor(.gray)
                    .font(.subheadline)
            }
            
            Spacer()
            
            Button {
                Task {
                    await coinViewModel.toggleFavorite(for: coin.id)
                }
            } label: {
                Image(systemName: coinViewModel.isFavorite(coin.id) ? "star.fill" : "star")
                    .foregroundColor(AppColors.yellow)
                    .font(.title2)
            }
        }
    }
    
    private var priceCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Current Price")
                .foregroundColor(.gray)
                .font(.subheadline)
            
            Text(coin.currentPrice.asCurrencyString())
                .foregroundColor(.white)
                .font(.system(size: 32, weight: .bold))
            
            Text((coin.priceChangePercentage24H ?? 0).asPercentString())
                .foregroundColor((coin.priceChangePercentage24H ?? 0) >= 0 ? AppColors.green : AppColors.red)
                .font(.headline)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(AppColors.card)
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }
    
    private var chartSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Price Chart")
                    .foregroundColor(.white)
                    .font(.headline)
                
                Spacer()
                
                HStack(spacing: 8) {
                    ForEach(dayOptions, id: \.self) { day in
                        Button {
                            selectedDays = day
                            Task {
                                await loadChart()
                            }
                        } label: {
                            Text("\(day)D")
                                .font(.caption.bold())
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(selectedDays == day ? AppColors.yellow : AppColors.card)
                                .foregroundColor(selectedDays == day ? .black : .white)
                                .clipShape(Capsule())
                        }
                    }
                }
            }
            
            if isLoadingChart {
                ProgressView()
                    .tint(AppColors.yellow)
                    .frame(maxWidth: .infinity, minHeight: 260)
            } else if chartPrices.isEmpty {
                Text("Chart data unavailable.")
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, minHeight: 260)
            } else {
                Chart {
                    ForEach(Array(chartPrices.enumerated()), id: \.offset) { index, price in
                        LineMark(
                            x: .value("Point", index),
                            y: .value("Price", price)
                        )
                        .foregroundStyle((coin.priceChangePercentage24H ?? 0) >= 0 ? AppColors.green : AppColors.red)
                        
                        AreaMark(
                            x: .value("Point", index),
                            y: .value("Price", price)
                        )
                        .foregroundStyle(
                            LinearGradient(
                                colors: [
                                    ((coin.priceChangePercentage24H ?? 0) >= 0 ? AppColors.green : AppColors.red).opacity(0.35),
                                    Color.clear
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                    }
                }
                .chartXAxis(.hidden)
                .chartYAxis {
                    AxisMarks(position: .leading)
                }
                .frame(height: 260)
                .padding(.top, 8)
            }
        }
        .padding()
        .background(AppColors.card)
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }
    
    private var statsSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Statistics")
                .foregroundColor(.white)
                .font(.headline)
            
            DetailStatRow(title: "24H High", value: coin.high24H?.asCurrencyString() ?? "-")
            DetailStatRow(title: "24H Low", value: coin.low24H?.asCurrencyString() ?? "-")
            DetailStatRow(title: "Market Cap", value: coin.marketCap?.formattedWithAbbreviations() ?? "-")
            DetailStatRow(title: "Total Volume", value: coin.totalVolume?.formattedWithAbbreviations() ?? "-")
            DetailStatRow(title: "Circulating Supply", value: coin.circulatingSupply?.formattedWithAbbreviations() ?? "-")
            DetailStatRow(title: "Rank", value: coin.marketCapRank != nil ? "#\(coin.marketCapRank!)" : "-")
        }
        .padding()
        .background(AppColors.card)
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }
    
    private func loadChart() async {
        isLoadingChart = true
        chartPrices = await coinViewModel.chartPrices(for: coin.id, days: selectedDays)
        isLoadingChart = false
    }
}

struct DetailStatRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.gray)
            Spacer()
            Text(value)
                .foregroundColor(.white)
                .fontWeight(.semibold)
        }
        .padding(.vertical, 4)
    }
}
