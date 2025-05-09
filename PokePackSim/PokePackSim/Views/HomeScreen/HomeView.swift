//
//  HomeView.swift
//  PokePackSim
//
//  Created by Kevin Dai on 4/13/25.
//

import SwiftData
import SwiftUI

struct HomeView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.modelContext) private var modelContext
    @State private var packViewModel = PackViewModel()

    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemBackground)
                    .ignoresSafeArea()

                VStack(spacing: 40) {
                    Text("Pokémon Pack Simulator")
                        .font(.title)
                        .fontWeight(.bold)
                        .fontDesign(.rounded)
                        .foregroundStyle(Color.primary)
                        .padding(.top, 30)

                    VStack(spacing: 25) {
                        NavigationLink(destination: PackOpeningView(viewModel: packViewModel)) {
                            HomeButtonView(
                                title: "Open Packs",
                                iconName: "sparkles"
                            )
                        }

                        NavigationLink(destination: CollectionView()) {
                            HomeButtonView(
                                title: "My Collection",
                                iconName: "books.vertical"
                            )
                        }
                    }

                    Spacer()
                }
                .padding()
            }
        }
    }
}

struct HomeButtonView: View {
    let title: String
    let iconName: String

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: iconName)
                .resizable()
                .scaledToFit()
                .frame(height: 50)
                .foregroundColor(.primary)

            Text(title)
                .font(.title3)
                .fontWeight(.medium)
                .foregroundColor(.primary)
        }
        .frame(width: 320, height: 270)
        .background(
            RoundedRectangle(cornerRadius: 30)
                .fill(.ultraThinMaterial)
                .background(Color.gray.opacity(0.05))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 30)
                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
        )
    }
}

#Preview {
    HomeView()
}
