//
//  CoinRowView.swift
//  CryptoApp
//
//  Created by Майлс on 09.11.2021.
//

import SwiftUI

struct CoinRowView: View {
    ///Свойство связывающее с свойство типа State извне
    let showHoldingsColumn: Bool
    ///Свойство для обозначения модели валюты во View
    let coin: CoinModel
    
    var body: some View {
        HStack(spacing: 0) {
            leftSideColumn
            Spacer()
            if showHoldingsColumn {
               centerSideColumn
            }
            rightSideColumn
        }
        .font(.subheadline)
        .background(Color.colorsTheme.background.opacity(0.001))
    }
}

//MARK: - VIEWS
extension CoinRowView {
    ///Левая сторона листа с валютой, содержит нумерацию, изображение валюты и символ(Например BTC)
    private var leftSideColumn: some View {
        HStack {
            Text("\(coin.rank)")
                .font(.caption)
                .foregroundColor(Color.colorsTheme.secondaryText)
                .frame(minWidth: 30)
            CoinImageView(coin: coin)
                .frame(width: 30, height: 30)
            Text(coin.symbol.uppercased())
                .font(.headline)
                .padding(.leading, 6)
                .foregroundColor(Color.colorsTheme.accent)
        }
    }
    ///Центр листа с валютой, содержит стоймость и количество той валюты, которой владее пользователь.
    private var centerSideColumn: some View {
        VStack(alignment: .trailing) {
            Text(coin.currentHoldingsValue.asCurrencyWith2Decimal())
                .bold()
            Text((coin.currentHoldings ?? 0).asNumberAsString())
        }
        .foregroundColor(Color.colorsTheme.accent)
    }
    ///Правая сторона листа с валютой, содержит текущую стоймость представленной валюты и процентное соотношение стоймости по сравнению с предыдущей версией представленной валюты
    private var rightSideColumn: some View {
        VStack(alignment: .trailing) {
            Text("\(coin.currentPrice.asCurrencyWith6Decimal())")
                .bold()
                .foregroundColor(Color.colorsTheme.accent)
            Text(coin.priceChangePercentage24H?.asPercentString() ?? "")
                .foregroundColor((coin.priceChangePercentage24H ?? 0) >= 0 ?
                                 Color.colorsTheme.green :
                                    Color.colorsTheme.red)
        }
        .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
    }
}

//MARK: - PREVIEW
struct CoinRowView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CoinRowView(showHoldingsColumn: true, coin: dev.coin)
                .previewLayout(.sizeThatFits)
            CoinRowView(showHoldingsColumn: true, coin: dev.coin)
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
        }
    }
}
