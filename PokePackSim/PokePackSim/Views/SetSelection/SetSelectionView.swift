//
//  SetSelectionView.swift
//  PokePackSim
//
//  Created by Kevin Dai on 4/23/25.
//

import SwiftUI

struct SetSelectionView: View {
    @Environment(\.dismiss) var dismiss
    @State private var viewModel = SetSelectionViewModel()
    @Binding var selectedSetId: String
    
    var body: some View {
        NavigationStack {
            List(viewModel.availableSets.reversed()) { set in
                Button(action: {
                    selectedSetId = set.id
                    dismiss()
                }) {
                    HStack {
                        if let logoUrl = set.logoUrl {
                            AsyncImage(url: URL(string: logoUrl)) { image in
                                image.resizable()
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 30, height: 30)
                        }

                        VStack(alignment: .leading) {
                            Text(set.name)
                            Text(set.series)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }

                        Spacer()

                        if selectedSetId == set.id {
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
            .navigationTitle("Select Pokémon Set")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .onAppear {
                if viewModel.availableSets.isEmpty {
                    Task {
                        await viewModel.loadSets()
                    }
                }
            }
        }
    }
}
