//
//  PackViewModel.swift
//  PokePackSim
//
//  Created by Kevin Dai on 4/13/25.
//

import Foundation
import SwiftData
import SwiftUI

@Observable
class PackViewModel {
    var selectedSetId: String = "" {
        didSet {
            pack.removeAll()
            currentSetLogo = availableSets.last { $0.id == selectedSetId }?.logoUrl
            selectedSetName = availableSets.last { $0.id == selectedSetId }?.name ?? "Unknown Set"
            Task {
                await loadCards()
            }
        }
    }

    var availableSets: [PokemonSet] = []
    var currentSetLogo: String?
    var selectedSetName: String = "Vivid Voltage"
    var pack: [Card] = []
    var isLoading = false
    var showMissingRaritiesAlert = false

    private let cardService = CardService()

    private var commons: [Card] = []
    private var uncommons: [Card] = []
    private var rares: [Card] = []

    init() {
        Task {
            await fetchAvailableSets()
        }
    }

    func fetchAvailableSets() async {
        do {
            availableSets = try await cardService.fetchAvailableSets()
            if selectedSetId.isEmpty, let firstSet = availableSets.last {
                selectedSetId = firstSet.id
            }
        } catch {
            print("Error fetching sets: \(error)")
            // Fallback to default
        }
    }

    func loadCards() async {
        isLoading = true
        do {
            async let commonsFetch = cardService.fetchCards(rarity: "Common", set: selectedSetId)
            async let uncommonsFetch = cardService.fetchCards(rarity: "Uncommon", set: selectedSetId)
            async let rareFetch = cardService.fetchCards(rarity: "Rare", set: selectedSetId)
            async let legendFetch = cardService.fetchCards(rarity: "LEGEND", set: selectedSetId)
            async let promoFetch = cardService.fetchCards(rarity: "Promo", set: selectedSetId)
            async let classicFetch = cardService.fetchCards(rarity: "Classic Collection", set: selectedSetId)

            commons = try await commonsFetch
            uncommons = try await uncommonsFetch

            let rare = try await rareFetch
            let legendRares = try await legendFetch
            let promoRares = try await promoFetch
            let classic = try await classicFetch

            rares = rare + legendRares + promoRares + classic

            if commons.isEmpty || uncommons.isEmpty || rares.isEmpty {
                showMissingRaritiesAlert = true
            }
        } catch {
            print("Error loading cards: \(error)")
        }
        isLoading = false
    }

    func openPack(context: ModelContext) {
        guard !commons.isEmpty || !uncommons.isEmpty || !rares.isEmpty else {
            print("No cards available to open a pack.")
            return
        }

        var newPack: [Card] = []

        if !commons.isEmpty {
            newPack += commons.shuffled().prefix(min(5, commons.count))
        }

        if !uncommons.isEmpty {
            newPack += uncommons.shuffled().prefix(min(3, uncommons.count))
        }

        if !rares.isEmpty {
            newPack += rares.shuffled().prefix(1)
        }

        // Save to SwiftData (avoiding duplicates)
        saveToCollection(newPack, context: context)

        // Update UI pack
        pack = newPack
    }

    private func saveToCollection(_ cards: [Card], context: ModelContext) {
        for card in cards {
            // Check for duplicates before inserting
            let descriptor = FetchDescriptor<Card>(predicate: #Predicate { $0.id == card.id })
            if let existing = try? context.fetch(descriptor), existing.isEmpty {
                context.insert(card)
            }
        }
        try? context.save()
    }
}
