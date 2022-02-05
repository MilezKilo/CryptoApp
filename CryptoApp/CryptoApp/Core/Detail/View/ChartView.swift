//
//  ChartView.swift
//  CryptoApp
//
//  Created by Майлс on 03.02.2022.
//

import SwiftUI

struct ChartView: View {
    
    private let data: [Double]
    private let maxY: Double
    private let minY: Double
    
    private let lineColor: Color
    
    private let startingDate: Date
    private let endingDate: Date
    
    @State private var percantage: CGFloat = 1
    
    init(coin: CoinModel) {
        data = coin.sparklineIn7D?.price ?? []
        maxY = data.max() ?? 0
        minY = data.min() ?? 0
        
        let priceChange = (data.last ?? 0) - (data.first ?? 0)
        lineColor = priceChange > 0 ? Color.colorsTheme.green : Color.colorsTheme.red
        
        endingDate = Date(coinGeckoString: coin.lastUpdated ?? "")
        startingDate = endingDate.addingTimeInterval(-7*24*60*60)
    }
    
    var body: some View {
        VStack {
            chartView
                .frame(height: 200)
                .background(chartBackground)
                .overlay(chartOverlay.padding(.horizontal, 4), alignment: .leading)
            chartDatelabel
        }
        .font(.caption)
        .foregroundColor(Color.colorsTheme.secondaryText)
        /*
        onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.linear(duration: 2.0)) {
                    percantage = 1.0
                }
            }
        }
         */
    }
}

//MARK: - EXTENSION
extension ChartView {
    private var chartView: some View {
        GeometryReader { geometry in
            Path { path in
                for index in data.indices {

                    let xPosition = geometry.size.width / CGFloat(data.count) * CGFloat(index + 1)
                    
                    let yAxes = maxY - minY
                    
                    let yPosition = (1 - CGFloat((data[index] - minY) / yAxes)) * geometry.size.height
                    
                    if index == 0 {
                        path.move(to: CGPoint(x: xPosition, y: yPosition))
                    }
                    path.addLine(to: CGPoint(x: xPosition, y: yPosition))
                }
            }
            .trim(from: 0, to: percantage)
            .stroke(lineColor, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
            .shadow(color: lineColor, radius: 10, x: 0, y: 10.0)
            .shadow(color: lineColor.opacity(0.5), radius: 10, x: 0, y: 20.0)
            .shadow(color: lineColor.opacity(0.2), radius: 10, x: 0, y: 30.0)
            .shadow(color: lineColor.opacity(0.1), radius: 10, x: 0, y: 40.0)
        }
    }
    private var chartBackground: some View {
        VStack {
            Divider()
            Spacer()
            Divider()
            Spacer()
            Divider()
        }
    }
    private var chartOverlay: some View {
        VStack {
            Text(maxY.formattedWithAbbreviations())
            Spacer()
            Text(((maxY + minY) / 2).formattedWithAbbreviations())
            Spacer()
            Text(minY.formattedWithAbbreviations())
        }
    }
    private var chartDatelabel: some View {
        HStack {
            Text(startingDate.dateAsString())
            Spacer()
            Text(endingDate.dateAsString())
        }
    }
}


//MARK: - PREVIEW
struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView(coin: dev.coin)
            .preferredColorScheme(.dark)
    }
}
