//
//  CardService.swift
//  PokePackSim
//
//  Created by Kevin Dai on 4/13/25.
//

import Foundation

class CardService {
    private let apiKey = "f8cd28b9-9ca7-419e-b8e4-57d9ba9f8760"
    private let baseURL = "https://api.pokemontcg.io/v2/cards"
    
    func fetchCards(rarity: String, set: String) async throws -> [Card] {
        let query = "set.id:\(set) rarity:\"\(rarity)\""
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "\(baseURL)?q=\(encodedQuery)") else
        {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.setValue(apiKey, forHTTPHeaderField: "X-Api-Key")
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let response = try JSONDecoder().decode(CardResponse.self, from: data)
            return response.data
        } catch {
            print("Error fetching cards: \(error)")
            throw error
        }
    }
    
    func fetchAvailableSets() async throws -> [PokemonSet] {
        let url = URL(string: "https://api.pokemontcg.io/v2/sets")!
        var request = URLRequest(url: url)
        request.setValue(apiKey, forHTTPHeaderField: "X-Api-Key")
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let response = try JSONDecoder().decode(SetResponse.self, from: data)
        return response.data
    }
}
