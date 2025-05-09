//
//  Models.swift
//  PokePackSim
//
//  Created by Kevin Dai on 4/13/25.
//

import Foundation
import SwiftData

struct CardResponse: Codable {
    let data: [Card]
}

@Model
class Card: Codable, Identifiable {
    var id: String
    var name: String
    var images: CardImages
    var rarity: String?
    var types: [String]?
    var hp: String?
    var set: PokemonSet

    enum CodingKeys: CodingKey {
        case id
        case name
        case images
        case rarity
        case types
        case hp
        case set
    }

    init(id: String, name: String, images: CardImages, rarity: String?, types: [String]?, hp: String?, set: PokemonSet) {
        self.id = id
        self.name = name
        self.images = images
        self.rarity = rarity
        self.types = types
        self.hp = hp
        self.set = set
    }

    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let id = try container.decode(String.self, forKey: .id)
        let name = try container.decode(String.self, forKey: .name)
        let images = try container.decode(CardImages.self, forKey: .images)
        let rarity = try container.decodeIfPresent(String.self, forKey: .rarity)
        let types = try container.decodeIfPresent([String].self, forKey: .types)
        let hp = try container.decodeIfPresent(String.self, forKey: .hp)
        let set = try container.decode(PokemonSet.self, forKey: .set)

        self.init(id: id, name: name, images: images, rarity: rarity, types: types, hp: hp, set: set)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(images, forKey: .images)
        try container.encode(rarity, forKey: .rarity)
        try container.encode(types, forKey: .types)
        try container.encode(hp, forKey: .hp)
        try container.encode(set, forKey: .set)
    }
}

extension Card {
    var isRare: Bool {
        guard let rarity = rarity?.lowercased() else { return false }
        return rarity.contains("rare") || rarity.contains("legend") || rarity.contains("promo")
    }
}

@Model
class CardImages: Codable {
    var small: String
    var large: String

    init(small: String, large: String) {
        self.small = small
        self.large = large
    }

    enum CodingKeys: CodingKey {
        case small
        case large
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.small = try container.decode(String.self, forKey: .small)
        self.large = try container.decode(String.self, forKey: .large)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(small, forKey: .small)
        try container.encode(large, forKey: .large)
    }
}

@Model
class PokemonSet: Codable, Identifiable {
    var id: String
    var name: String
    var images: SetImages?
    var series: String

    init(id: String, name: String, images: SetImages?, series: String) {
        self.id = id
        self.name = name
        self.images = images
        self.series = series
    }

    enum CodingKeys: CodingKey {
        case id
        case name
        case images
        case series
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.images = try container.decodeIfPresent(SetImages.self, forKey: .images)
        self.series = try container.decode(String.self, forKey: .series)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encodeIfPresent(images, forKey: .images)
        try container.encode(series, forKey: .series)
    }

    var logoUrl: String? {
        images?.logo ?? images?.symbol
    }
}

@Model
class SetImages: Codable {
    var symbol: String?
    var logo: String?

    init(symbol: String?, logo: String?) {
        self.symbol = symbol
        self.logo = logo
    }

    enum CodingKeys: CodingKey {
        case symbol
        case logo
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.symbol = try container.decodeIfPresent(String.self, forKey: .symbol)
        self.logo = try container.decodeIfPresent(String.self, forKey: .logo)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(symbol, forKey: .symbol)
        try container.encodeIfPresent(logo, forKey: .logo)
    }
}

struct SetResponse: Codable {
    let data: [PokemonSet]
}
