//
//  PackOpeningView.swift
//  PokePackSim
//
//  Created by Kevin Dai on 4/13/25.
//

import SwiftData
import SwiftUI

struct PackOpeningView: View {
    @Environment(\.modelContext) var modelContext
    @State private var viewModel: PackViewModel
    @State private var showingSetSelection = false

    init(viewModel: PackViewModel) {
        self._viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            VStack {
                Button(action: {
                    showingSetSelection = true
                }) {
                    VStack(spacing: 8) {
                        if let setLogo = viewModel.currentSetLogo {
                            AsyncImage(url: URL(string: setLogo)) { phase in
                                switch phase {
                                case .success(let image):
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 80)
                                        .padding(10)
                                        .background(.ultraThinMaterial)
                                        .cornerRadius(12)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(Color.blue, lineWidth: 2)
                                        )
                                case .failure:
                                    Image(systemName: "square.stack.3d.up.fill")
                                        .font(.largeTitle)
                                        .foregroundColor(.blue)
                                default:
                                    ProgressView()
                                        .frame(height: 80)
                                }
                            }
                        } else {
                            Image(systemName: "square.stack.3d.up.fill")
                                .font(.largeTitle)
                                .foregroundColor(.blue)
                        }

                        Text("Tap to change set")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.top)

                if viewModel.isLoading {
                    ProgressView("Loading...")
                } else {
                    if viewModel.pack.isEmpty {
                        Text("Open a pack to see your cards!")
                            .padding()
                    } else {
                        ScrollView {
                            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 16) {
                                ForEach(viewModel.pack) { card in
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
                                }
                            }
                            .padding()
                        }
                    }

                    Button(action: {
                        viewModel.openPack(context: modelContext)
                    }) {
                        Text("Open Pack")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding()
                }
            }
            .navigationTitle("Pokémon Pack Simulator")
            .sheet(isPresented: $showingSetSelection) {
                SetSelectionView(selectedSetId: $viewModel.selectedSetId)
            }
            .alert("This set either contains missing or special rarities", isPresented: $viewModel.showMissingRaritiesAlert) {
                Button("OK", role: .cancel) {}
            }
            .onAppear {
                Task {
                    await viewModel.loadCards()
                }
            }
            .onChange(of: viewModel.selectedSetId) { _ in
                Task {
                    await viewModel.loadCards()
                }
            }
        }
    }
}
