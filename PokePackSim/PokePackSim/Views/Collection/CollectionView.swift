//
//  CollectionView.swift
//  PokePackSim
//
//  Created by Kevin Dai on 4/13/25.
//

import SwiftData
import SwiftUI

struct CollectionView: View {
    @Query(sort: \Card.name) var collectedCards: [Card]

    var body: some View {
        NavigationStack {
            VStack {
                if collectedCards.isEmpty {
                    Text("Your collection is empty!")
                        .padding()
                } else {
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 16) {
                            ForEach(collectedCards) { card in
                                NavigationLink(destination: CardDetailView(card: card)) {
                                    AsyncImage(url: URL(string: card.images.small)) { image in
                                        image
                                            .resizable()
                                            .scaledToFit()
                                            .cornerRadius(8)
                                    } placeholder: {
                                        ProgressView()
                                            .frame(height: 120)
                                    }
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("My Collection")
        }
    }
}
