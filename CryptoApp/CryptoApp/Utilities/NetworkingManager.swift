//
//  NetworkingManager.swift
//  CryptoApp
//
//  Created by Майлс on 11.11.2021.
//

import Foundation
import Combine

class NetworkingManager {
    
    ///Перечисление ошибок соединения
    enum NetworkingError: LocalizedError {
        case badURLResponce(url: URL)
        case unknown
        
        var errorDescription: String? {
            switch self {
            case .badURLResponce(url: let url): return "[🔥] Bad responce from url: \(url)"
            case .unknown: return "[⚠️] Unknown error occured"
            }
        }
    }
    
    ///Метод типа NetworkingManager, содержит в себе повторяющийся код для получения данных:
    /// ```
    /// .subscribe - Подписывает на получение данных в фоновом потоке
    /// .trymap - Карта проверки на ошибки
    /// .receive - Получение данных в основном потоке
    /// .eraseToAnyPublisher - Преобразование возвращаемого типа к AnyPublisher<Data, Error> (любому Publisher'y)
    /// ```
    static func download(url: URL) -> AnyPublisher<Data, Error> {
        return URLSession.shared.dataTaskPublisher(for: url)
//            .subscribe(on: DispatchQueue.global(qos: .default))
            .tryMap({ try handleURLResponce(output: $0, url: url) })
            .retry(3)
//            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    ///Метод типа NetworkingManager, содержит в себе проверку ошибок для метода tryMap
    static func handleURLResponce(output: URLSession.DataTaskPublisher.Output, url: URL) throws -> Data {
        guard let responce = output.response as? HTTPURLResponse,
        responce.statusCode >= 200 && responce.statusCode < 300 else {
            throw NetworkingError.badURLResponce(url: url)
        }
        return output.data
    }
    
    ///Метод типа NetworkingManager, содержит в себе какие либо действия при завершении получения данных с API
    /// ```
    /// .complition: Subscribers.Completion<Error> содержит в себе 2 кейса
    /// .finished - прерывает действие в случае успеха
    /// .failure - выводит точное описание ошибки
    /// ```
    static func handleComplition(complition: Subscribers.Completion<Error>) {
        switch complition {
        case .finished:
            break
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
}
