//
//  SetSelectionViewModel.swift
//  PokePackSim
//
//  Created by Kevin Dai on 4/23/25.
//

import Foundation

@Observable
class SetSelectionViewModel {
    var availableSets: [PokemonSet] = []
    var isLoading = false
    var error: Error?

    func loadSets() async {
        isLoading = true
        error = nil
        do {
            availableSets = try await CardService().fetchAvailableSets()
        } catch {
            self.error = error
        }
        isLoading = false
    }
}
