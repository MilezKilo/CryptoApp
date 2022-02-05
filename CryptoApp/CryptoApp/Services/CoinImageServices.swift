//
//  CoinImageServices.swift
//  CryptoApp
//
//  Created by Майлс on 01.12.2021.
//

import Foundation
import SwiftUI
import Combine

class CoinImageService: ObservableObject {
    
    /// Свойство содержащие в себе скаченные с сервера изображения валюты
    @Published var image: UIImage? = nil
    
    ///Свойство, которое получает данные об изоброажениях валюты с сервера
    /// ```
    /// sink - Наблюдает за изменениями в данном свойстве, использует NetworkingManager.handleComplition с определенным набором кейсов действий
    /// В случае успеха возвращает данные с сервера о валюте
    /// self?.imageSubscription?.cancel() - отменяет активные действия
    /// ```
    private var imageSubscription: AnyCancellable?
    private let coin: CoinModel
    private let fileManager = LocalFileManager.instance
    private let folderName = "coin_images"
    private let imageName: String
    
    init(coin: CoinModel) {
        self.coin = coin
        self.imageName = coin.id
        getCoinImage()
    }
    
    ///Метод проверяющий наличие изображения валюты в файловом менеджере, если ее нет, вызывается метод downloadCoinImage
    private func getCoinImage() {
        if let savedImages = fileManager.getImage(imageName: imageName, folderName: folderName) {
            image = savedImages
        } else {
            downloadCoinImage()
        }
    }
    
    ///Приватный метод получения JSON данных с сервера об изображениях валюты, используется только при вызове данного класса
    private func downloadCoinImage() {
        guard let url = URL(string: coin.image) else { return }
        
        imageSubscription = NetworkingManager.download(url: url)
            .tryMap({ (data) -> UIImage? in
                return UIImage(data: data)
            })
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleComplition, receiveValue: { [weak self] returnedImage in
                guard let self = self, let downloadedImage = returnedImage else { return }
                self.image = downloadedImage
                self.imageSubscription?.cancel()
                self.fileManager.saveImage(image: downloadedImage, imageName: self.imageName, folderName: self.folderName)
            })
    }
}
