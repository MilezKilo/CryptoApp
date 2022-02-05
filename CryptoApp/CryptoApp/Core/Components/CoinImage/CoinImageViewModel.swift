//
//  CoinImageViewModel.swift
//  CryptoApp
//
//  Created by Майлс on 01.12.2021.
//

import SwiftUI
import Combine

class CoinImageViewModel: ObservableObject {
    
    ///Свойство, содержащие в себе полученное с сервера изображение, все кто подпишутся на данный паблишер, получат изображение
    @Published var image: UIImage?
    ///Свойство, проверяет загружается ли изображение с сервера
    @Published var isLoading: Bool = false
    
    
    private var coin: CoinModel
    private var dataService: CoinImageService
    private var cancellables = Set<AnyCancellable>()
    
    init(coin: CoinModel) {
        self.coin = coin
        self.dataService = CoinImageService(coin: coin)
        self.addSubsribers()
        self.isLoading = true
    }
    
    private func addSubsribers() {
        dataService.$image
            .sink { [weak self] _ in
                //Если изображение по какой то причине не будет получено, свойство isLoading станет false
                self?.isLoading = false
            } receiveValue: { [weak self] returnedImage in
                self?.image = returnedImage
            }
            .store(in: &cancellables)
    }
}
