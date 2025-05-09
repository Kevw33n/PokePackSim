//
//  CollectionViewModel.swift
//  PokePackSim
//
//  Created by Kevin Dai on 4/16/25.
//

import SwiftData
import SwiftUI

@Observable
class CollectionViewModel {
    var collectedCards: [Card] = []

    func loadCards(from context: ModelContext) {
        let descriptor = FetchDescriptor<Card>(sortBy: [SortDescriptor(\.name)])
        do {
            collectedCards = try context.fetch(descriptor)
        } catch {
            print("Failed to fetch collected cards: \(error)")
        }
    }
}
