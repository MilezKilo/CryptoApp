//
//  PortfolioDataService.swift
//  CryptoApp
//
//  Created by Майлс on 29.01.2022.
//

import Foundation
import CoreData

class PortfolioDataService {
    
    private let container: NSPersistentContainer
    private let contatinerName = "PortfolioContainer"
    private let entityName = "PortfolioEntity"
    
    @Published var savedEntities: [PortfolioEntity] = []
    
    init() {
        container = NSPersistentContainer(name: contatinerName)
        container.loadPersistentStores { _, error in
            if let error = error {
                print("Error load core data! \(error)")
            }
        }
        self.getPortfolio()
    }
    
    //ПУБЛИЧНЫЕ МЕТОДЫ
    func updatePortfolio(coin: CoinModel, amount: Double) {
        if let entity = savedEntities.first(where: { $0.coinID == coin.id }) {
            if amount > 0 {
                update(entity: entity, amount: amount)
            } else {
                delete(entity: entity)
            }
        } else {
            add(coin: coin, amount: amount)
        }
    }
    
    //ПРИВАТНЫЕ МЕТОДЫ
    private func getPortfolio() {
        let request = NSFetchRequest<PortfolioEntity>(entityName: entityName)
        do {
            savedEntities = try container.viewContext.fetch(request)
        } catch let error {
            print("Error fetching portfolio entity: \(error)")
        }
    }
    private func add(coin: CoinModel, amount: Double) {
        let entity = PortfolioEntity(context: container.viewContext)
        entity.coinID = coin.id
        entity.amount = amount
        applyChanges()
    }
    private func update(entity: PortfolioEntity, amount: Double) {
        entity.amount = amount
        applyChanges()
    }
    private func delete(entity: PortfolioEntity) {
        container.viewContext.delete(entity)
        applyChanges()
    }
    private func save() {
        do {
            try container.viewContext.save()
        } catch let error {
            print("Error save to core data: \(error)")
        }
    }
    private func applyChanges() {
        save()
        getPortfolio()
    }
}
