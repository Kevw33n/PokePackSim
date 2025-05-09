//
//  ContentView.swift
//  PokePackSim
//
//  Created by Kevin Dai on 4/13/25.
//

import SwiftData
import SwiftUI
import WidgetKit

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var cards: [Card]
    var body: some View {
        HomeView()
            .task {
                let notifications = NotificationCenter.default.notifications(named: ModelContext.didSave)
                
                for await _ in notifications {
                    WidgetCenter.shared.reloadAllTimelines()
                }
            }
    }
}

#Preview {
    ContentView()
}
