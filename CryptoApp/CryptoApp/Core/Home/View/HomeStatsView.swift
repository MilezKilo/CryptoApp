//
//  HomeStatsView.swift
//  CryptoApp
//
//  Created by Майлс on 21.01.2022.
//

import SwiftUI

struct HomeStatsView: View {
    
    //В данном файле создана структура отображающая подзаголовочный файл
    @EnvironmentObject private var vm: HomeViewModel
    
    @Binding var showPortfolio: Bool
    
    var body: some View {
        HStack {
            ForEach(vm.statistics) { stat in
                StatisticView(statistic: stat)
                    .frame(width: UIScreen.main.bounds.width / 3)
            }
        }
        .frame(width: UIScreen.main.bounds.width, alignment: showPortfolio ? .trailing : .leading)
    }
}


//MARK: - PREVIEW
struct HomeStatsView_Previews: PreviewProvider {
    static var previews: some View {
        HomeStatsView(showPortfolio: .constant(false))
            .environmentObject(HomeViewModel())
    }
}
