//
//  CardDetailView.swift
//  PokePackSim
//
//  Created by Kevin Dai on 4/16/25.
//

import SwiftUI

struct CardDetailView: View {
    let card: Card
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                AsyncImage(url: URL(string: card.images.large)) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(12)
                        .shadow(radius: 10)
                } placeholder: {
                    ProgressView()
                        .frame(width: 200, height: 300)
                }
                .frame(maxWidth: .infinity)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text(card.name)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    HStack {
                        Text(card.set.name)
                            .font(.headline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.bottom, 5)
                    
                    HStack {
                        Text(card.rarity ?? "Unknown Rarity")
                            .font(.headline)
                            .padding(5)
                            .background(.yellow.opacity(0.3))
                            .cornerRadius(5)
                        
                        Text(card.types?.first ?? "Unknown Type")
                            .font(.headline)
                            .padding(5)
                            .background(.blue.opacity(0.3))
                            .cornerRadius(5)
                    }
                }
                .padding()
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle(card.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}
