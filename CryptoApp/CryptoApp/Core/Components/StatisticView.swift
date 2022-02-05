//
//  StatisticView.swift
//  CryptoApp
//
//  Created by Майлс on 21.01.2022.
//

import SwiftUI

struct StatisticView: View {
    
    //В данном файле описано то, как должен выглядеть подзаголовочный файл
    let statistic: StatisticModel
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 4) {
            Text(statistic.title)
                .font(.caption)
                .foregroundColor(Color.colorsTheme.secondaryText)
            Text(statistic.value)
                .font(.headline)
                .foregroundColor(Color.colorsTheme.accent)
            HStack {
                Image(systemName: "triangle.fill")
                    .font(.caption2)
                    .rotationEffect(Angle(degrees: (statistic.percentageChange ?? 0) >= 0 ? 0 : 180))
                Text(statistic.percentageChange?.asPercentString() ?? "")
                    .font(.caption)
                .bold()
            }
            .foregroundColor((statistic.percentageChange ?? 0) >= 0 ? Color.colorsTheme.green : Color.colorsTheme.red)
            .opacity(statistic.percentageChange == nil ? 0.0 : 1.0)
        }
    }
}

//MARK: - PREVIEW
struct StatisticView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticView(statistic: dev.stat1)
            .previewLayout(.sizeThatFits)
            .padding()
        StatisticView(statistic: dev.stat2)
            .previewLayout(.sizeThatFits)
            .padding()
        StatisticView(statistic: dev.stat3)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
